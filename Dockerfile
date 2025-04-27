# syntax=docker/dockerfile:1
# Use Python 3.11 slim as the base image
FROM python:3.13-slim-bookworm

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY app/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY app/ .

# Create a non-root user and group
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Create necessary directories
RUN mkdir -p /app/templates && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Set environment variables
ENV FLASK_APP=app.py

# Command to run the application
CMD ["python", "app.py"] 