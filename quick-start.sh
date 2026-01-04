#!/bin/bash
# Quick start script for local development

set -e

echo "================================================"
echo "Starting VS Code Server"
echo "================================================"
echo ""

# Check if .env exists, if not copy from example
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo "Please edit .env file with your configuration before continuing."
    echo "Press Enter after you've configured .env, or Ctrl+C to exit..."
    read
fi

# Load environment variables safely
if [ -f .env ]; then
    set -o allexport
    source .env
    set +o allexport
fi

# Build and start the container
echo "Building Docker image..."
docker compose build

echo ""
echo "Starting container..."
docker compose up -d

echo ""
echo "================================================"
echo "VS Code Server is starting!"
echo "================================================"
echo ""
echo "Access your code-server at: http://localhost:8080"
echo "Password: Check your .env file (CODE_SERVER_PASSWORD)"
echo ""

# Show container logs
echo "Container logs (Ctrl+C to exit log view):"
docker compose logs -f
