# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies needed for building Python packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the pyproject.toml and poetry.lock files into the container
COPY pyproject.toml poetry.lock* /app/

# Install Poetry
RUN pip install --no-cache-dir poetry

# Install dependencies using Poetry
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev

# Copy the application code to the container
COPY src /app/src

# Expose the port the app runs on
EXPOSE 3003

# Run the FastAPI app with Uvicorn
CMD ["poetry", "run", "uvicorn", "src.sample_api.main:app", "--host", "0.0.0.0", "--port", "3003"]