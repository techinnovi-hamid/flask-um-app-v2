# Use a newer slim image with patched libc
FROM python:3.12.12-slim-bullseye AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip/setuptools/wheel
RUN pip install --upgrade pip setuptools wheel

# Install Python dependencies
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- Final runtime image ----
FROM python:3.12.12-slim-bullseye

WORKDIR /app

# Install runtime libraries
RUN apt-get update && apt-get install -y \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN useradd -m appuser

# Copy Python packages from builder
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application code
COPY app/ .

# Change ownership
RUN chown -R appuser:appuser /app

# Use non-root user
USER appuser

# Expose port and start app
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
