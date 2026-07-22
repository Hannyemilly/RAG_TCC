FROM python:3.11-slim

# Tesseract para OCR de PDFs escaneados (com idioma português)
RUN apt-get update && apt-get install -y --no-install-recommends \
    tesseract-ocr tesseract-ocr-por \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.docker.txt .
RUN pip install --no-cache-dir -r requirements.docker.txt

# Dados do NLTK usados na extração de texto (punkt_tab não é baixado em runtime)
RUN python -m nltk.downloader -d /usr/local/share/nltk_data punkt punkt_tab wordnet omw-1.4

COPY . .

# Cache dos modelos de ML (montar volume aqui para não baixar de novo a cada subida)
ENV HF_HOME=/models
ENV SENTENCE_TRANSFORMERS_HOME=/models

EXPOSE 3333

CMD ["python", "src/server.py"]
