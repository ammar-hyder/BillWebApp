FROM python:3.11-slim

# System deps for OCR/PDF and OpenCV
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tesseract-ocr \
        poppler-utils \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        libgl1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PYTHONUNBUFFERED=1 PORT=8000

CMD sh -c 'gunicorn -k gthread --threads 4 --timeout 180 --bind 0.0.0.0:${PORT:-8000} main:app'
