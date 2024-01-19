# Stage 1: Build stage
FROM python:3.9-slim AS builder

WORKDIR /app

COPY requirements.txt .

# Install dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Stage 2: Production stage
FROM python:3.9-slim AS final

WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn

COPY . .

# Expose the FastAPI application port
EXPOSE 8000

# Command to run the FastAPI application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
