FROM python:3.11-slim

# System deps for OCR/PDF
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tesseract-ocr \
        poppler-utils \
        libglib2.0-0 libsm6 libxext6 libxrender1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first (better cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your code
COPY . .

ENV PYTHONUNBUFFERED=1 PORT=8000

# Import your app from main.py -> app
CMD sh -c 'gunicorn -k gthread --threads 4 --timeout 180 --bind 0.0.0.0:${PORT:-8000} main:app'

