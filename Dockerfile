FROM python:3.11-slim

# Install Chrome, Chromedriver, and system deps for OCR/PDF/OpenCV
RUN apt-get update && apt-get install -y wget gnupg unzip --no-install-recommends && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        google-chrome-stable \
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
