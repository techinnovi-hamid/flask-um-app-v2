# ---------- Builder Stage ----------
FROM python:3.12-slim AS builder

WORKDIR /app

# Update OS packages and install build tools
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    gcc \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


# ---------- Runtime Stage ----------
FROM python:3.12-slim

WORKDIR /app

# Update OS packages to patch vulnerabilities
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m appuser

# Copy Python dependencies from builder
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application
COPY app/ .

# Permissions
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
