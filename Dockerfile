# Use Python 3.11 slim as the base image
FROM python:3.11-slim as builder

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY app/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY app/ .

# Create a non-root user
RUN useradd -m appuser

# Final stage
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app /app
COPY --from=builder /etc/passwd /etc/passwd

# Create necessary directories
RUN mkdir -p /app/templates && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose the port the app runs on
EXPOSE 3000

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Command to run the application
CMD ["python", "app.py"] 