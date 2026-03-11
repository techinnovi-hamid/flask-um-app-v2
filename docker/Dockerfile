# Stage 1 — builder
FROM python:3.12-slim-bookworm AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel

COPY app/requirements.txt .
<<<<<<< HEAD
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2 — runtime
FROM python:3.12-slim-bookworm
=======

RUN pip install --no-cache-dir -r requirements.txt


FROM python:3.12-slim

>>>>>>> ecb37c6 (repo_v2 fix dockerfile paths and remove postgres deployment)
WORKDIR /app

RUN apt-get update && apt-get install -y libpq5 && rm -rf /var/lib/apt/lists/*

RUN useradd -m appuser

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
<<<<<<< HEAD
=======

>>>>>>> ecb37c6 (repo_v2 fix dockerfile paths and remove postgres deployment)
COPY app/ .

RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
