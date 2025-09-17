# Simple, production-ish Dockerfile for the Flask app
FROM python:3.12-slim

# Avoid interactive tzdata etc.
ENV PYTHONDONTWRITEBYTECODE=1 \
PYTHONUNBUFFERED=1

WORKDIR /app

# Install runtime deps only (PyMySQL is pure-python, so no build tools needed)
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source and templates
COPY app.py ./
COPY templates ./templates

# Expose Flask port
EXPOSE 8000

# Default environment (override at runtime)
ENV DB_HOST=localhost \
    DB_PORT=3306 \
    DB_USER=demo \
    DB_PASSWORD=demopw \
    DB_NAME=demodb

CMD ["python", "app.py"]