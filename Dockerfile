FROM codercom/code-server:latest

USER root

# Update package lists
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    zip \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (LTS version)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && npm install -g yarn pnpm typescript ts-node

# Install Python 3 and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --upgrade pip setuptools wheel

# Install common Python packages
RUN pip3 install \
    pylint \
    black \
    flake8 \
    autopep8 \
    pytest \
    ipython \
    jupyter \
    numpy \
    pandas \
    requests

# Install Go
RUN wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz \
    && rm go1.21.5.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/home/coder/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Install Rust
USER coder
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/coder/.cargo/bin:${PATH}"

USER root
# Install Java (OpenJDK)
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    maven \
    gradle \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for development)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
    && curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update \
    && apt-get install -y tailscale \
    && rm -rf /var/lib/apt/lists/*

# Install additional development tools
RUN apt-get update && apt-get install -y \
    vim \
    nano \
    tmux \
    htop \
    tree \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Create directories for AI CLI tools
RUN mkdir -p /opt/ai-tools
USER coder

# Install VS Code extensions for language support
RUN code-server --install-extension ms-python.python \
    && code-server --install-extension ms-vscode.go \
    && code-server --install-extension rust-lang.rust-analyzer \
    && code-server --install-extension redhat.java \
    && code-server --install-extension vscjava.vscode-java-pack \
    && code-server --install-extension dbaeumer.vscode-eslint \
    && code-server --install-extension esbenp.prettier-vscode \
    && code-server --install-extension ms-vscode.vscode-typescript-next

# Install AI Assistant extensions (available ones)
RUN code-server --install-extension github.copilot || true \
    && code-server --install-extension github.copilot-chat || true \
    && code-server --install-extension continue.continue || true

# Set working directory
WORKDIR /home/coder/workspace

# Copy setup scripts
COPY --chown=coder:coder setup-scripts /opt/ai-tools/setup-scripts

# Expose code-server port
EXPOSE 8080

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/home/coder/workspace"]
