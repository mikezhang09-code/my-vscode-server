# Base image
FROM codercom/code-server:latest

# Switch to root to install dependencies
USER root

# Install basic tools and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install AI CLI tools and TypeScript globally
RUN npm install -g @anthropic-ai/claude-code @google/gemini-cli typescript

# Switch back to the coder user
USER coder

# Set default working directory
WORKDIR /home/coder/project
