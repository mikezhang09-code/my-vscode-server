# Setup Guide - My VS Code Server

This guide provides detailed step-by-step instructions for setting up your VS Code Server with AI assistants and multi-language support.

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Initial Setup](#initial-setup)
3. [Tailscale Configuration](#tailscale-configuration)
4. [AI Assistants Configuration](#ai-assistants-configuration)
5. [Advanced Configuration](#advanced-configuration)
6. [Deployment Options](#deployment-options)
7. [Troubleshooting](#troubleshooting)

## System Requirements

### Minimum Requirements
- **OS**: Linux, macOS, or Windows with WSL2
- **RAM**: 2GB (4GB recommended)
- **Storage**: 10GB free space
- **Docker**: Version 20.10 or later
- **Docker Compose**: Version 2.0 or later

### Recommended Requirements
- **RAM**: 8GB or more
- **Storage**: 20GB or more
- **CPU**: 4 cores or more

## Initial Setup

### Step 1: Install Docker

#### Linux (Ubuntu/Debian)
```bash
# Update package index
sudo apt-get update

# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

#### macOS
```bash
# Install Docker Desktop from https://www.docker.com/products/docker-desktop
# Or use Homebrew:
brew install --cask docker
```

#### Windows
1. Install Docker Desktop from https://www.docker.com/products/docker-desktop
2. Enable WSL2 backend
3. Install a Linux distribution from Microsoft Store (Ubuntu recommended)

### Step 2: Clone the Repository

```bash
git clone https://github.com/mikezhang09-code/my-vscode-server.git
cd my-vscode-server
```

### Step 3: Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit the file with your preferred editor
nano .env
# or
vim .env
# or
code .env
```

**Minimum required configuration:**
```bash
CODE_SERVER_PASSWORD=YourSecurePasswordHere123!
```

### Step 4: Start the Server

```bash
# Using the quick-start script
./quick-start.sh

# Or manually
docker-compose build
docker-compose up -d
```

### Step 5: Access Your Server

1. Open your web browser
2. Navigate to: `http://localhost:8080`
3. Enter your password (set in `.env`)

## Tailscale Configuration

Tailscale allows you to securely access your code-server from anywhere without exposing it to the public internet.

### Step 1: Create a Tailscale Account

1. Go to [https://tailscale.com](https://tailscale.com)
2. Sign up with your Google, GitHub, or Microsoft account
3. Install Tailscale on your client devices (laptop, phone, etc.)

### Step 2: Generate an Auth Key

1. Log in to [Tailscale Admin Console](https://login.tailscale.com/admin)
2. Go to **Settings** > **Keys**
3. Click **Generate auth key**
4. Options to select:
   - ✅ Reusable (if you plan to recreate the container)
   - ✅ Ephemeral (optional - node disappears when offline)
   - Set expiration (recommended: 90 days or longer)
5. Copy the generated key (starts with `tskey-auth-`)

### Step 3: Configure Tailscale in Your Setup

Add to your `.env` file:
```bash
TAILSCALE_AUTH_KEY=tskey-auth-xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Step 4: Enable Host Network Mode

Edit `docker-compose.yml`:

```yaml
services:
  code-server:
    # ... other settings ...
    network_mode: host  # Uncomment this line
    # Comment out the ports section:
    # ports:
    #   - "8080:8080"
```

### Step 5: Restart the Container

```bash
docker-compose down
docker-compose up -d
```

### Step 6: Get Your Tailscale IP

```bash
docker-compose exec code-server tailscale ip -4
```

You'll get an IP like: `100.x.x.x`

### Step 7: Access from Anywhere

On any device connected to your Tailscale network:
```
http://100.x.x.x:8080
```

## AI Assistants Configuration

### ChatGPT (OpenAI)

#### Step 1: Get API Key
1. Go to [OpenAI Platform](https://platform.openai.com)
2. Sign up or log in
3. Navigate to **API Keys** section
4. Click **Create new secret key**
5. Copy the key (starts with `sk-`)

#### Step 2: Configure
Add to `.env`:
```bash
OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### Step 3: Setup CLI
```bash
# Access the container
docker-compose exec code-server bash

# Run setup (happens automatically on first start, but you can run it manually)
bash /opt/ai-tools/setup-scripts/setup-chatgpt-cli.sh

# Test it
chatgpt-cli "Say hello!"
```

#### Usage Examples
```bash
# Ask a question
chatgpt-cli "What is Docker?"

# Get coding help
chatgpt-cli "Write a Python function to sort a list of dictionaries by a key"

# Debug code
chatgpt-cli "Why do I get 'TypeError: unsupported operand type(s)' in Python?"
```

### Claude (Anthropic)

#### Step 1: Get API Key
1. Go to [Anthropic Console](https://console.anthropic.com)
2. Sign up or log in
3. Navigate to **API Keys**
4. Create a new key
5. Copy the key (starts with `sk-ant-`)

#### Step 2: Configure
Add to `.env`:
```bash
ANTHROPIC_API_KEY=sk-ant-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### Step 3: Setup CLI
```bash
docker-compose exec code-server bash
bash /opt/ai-tools/setup-scripts/setup-claude-cli.sh
claude-cli "Hello!"
```

#### Usage Examples
```bash
# Code review
claude-cli "Review this code: [paste your code]"

# Explain concepts
claude-cli "Explain the difference between synchronous and asynchronous programming"

# Generate tests
claude-cli "Write unit tests for this function: [paste function]"
```

### Gemini (Google)

#### Step 1: Get API Key
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click **Get API Key**
4. Create a new API key
5. Copy the key

#### Step 2: Configure
Add to `.env`:
```bash
GOOGLE_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# or
GEMINI_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### Step 3: Setup CLI
```bash
docker-compose exec code-server bash
bash /opt/ai-tools/setup-scripts/setup-gemini-cli.sh
gemini-cli "Hello!"
```

#### Usage Examples
```bash
# Ask questions
gemini-cli "What are the best practices for REST API design?"

# Get code examples
gemini-cli "Show me an example of using async/await in JavaScript"

# Learn new topics
gemini-cli "Explain microservices architecture"
```

### GitHub Copilot

#### Step 1: Subscribe
1. Go to [GitHub Copilot](https://github.com/features/copilot)
2. Start a free trial or subscribe
3. Subscription costs $10/month or $100/year (free for students and open source maintainers)

#### Step 2: Sign In
1. Open code-server in your browser
2. Press `F1` or `Ctrl+Shift+P` (Cmd+Shift+P on Mac)
3. Type: `GitHub Copilot: Sign In`
4. Follow the authentication flow
5. Enter the code shown in VS Code on GitHub

#### Step 3: Use Copilot
- Start typing code and Copilot will suggest completions
- Press `Tab` to accept suggestions
- Press `Alt+]` for next suggestion
- Press `Alt+[` for previous suggestion

### Continue.dev

Continue.dev is pre-installed and provides inline AI assistance.

#### Step 1: Configure
1. In code-server, press `Ctrl+Shift+P`
2. Type: `Continue: Open Config`
3. Configure your preferred AI provider:

```json
{
  "models": [
    {
      "title": "GPT-4",
      "provider": "openai",
      "model": "gpt-4",
      "apiKey": "YOUR_OPENAI_API_KEY"
    },
    {
      "title": "Claude 3",
      "provider": "anthropic",
      "model": "claude-3-sonnet-20240229",
      "apiKey": "YOUR_ANTHROPIC_API_KEY"
    }
  ]
}
```

#### Step 2: Use Continue
- Highlight code and press `Ctrl+M` to ask Continue about it
- Use the Continue sidebar for chat
- Select code and use commands like "Explain", "Fix", "Optimize"

## Advanced Configuration

### Custom VS Code Settings

Edit `config/settings.json` before starting the container:

```json
{
  "workbench.colorTheme": "Monokai",
  "editor.fontSize": 16,
  "editor.fontFamily": "Fira Code",
  "editor.fontLigatures": true,
  "terminal.integrated.fontSize": 14
}
```

### Add More Languages

Edit the `Dockerfile` to add additional languages:

#### PHP
```dockerfile
RUN apt-get update && apt-get install -y \
    php \
    php-cli \
    php-mbstring \
    php-xml \
    composer \
    && rm -rf /var/lib/apt/lists/*

RUN code-server --install-extension bmewburn.vscode-intelephense-client
```

#### Ruby
```dockerfile
RUN apt-get update && apt-get install -y \
    ruby \
    ruby-dev \
    && rm -rf /var/lib/apt/lists/* \
    && gem install bundler

RUN code-server --install-extension rebornix.ruby
```

#### C/C++
```dockerfile
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    gdb \
    cmake \
    make \
    && rm -rf /var/lib/apt/lists/*

RUN code-server --install-extension ms-vscode.cpptools
```

### Persistent Storage

All your code and settings are stored in volumes:

```yaml
volumes:
  - ./workspace:/home/coder/workspace        # Your projects
  - ./config:/home/coder/.config/code-server # Code-server config
  - ./vscode-data:/home/coder/.local/share/code-server # Extensions and settings
```

### Resource Limits

Add resource limits in `docker-compose.yml`:

```yaml
services:
  code-server:
    # ... other settings ...
    deploy:
      resources:
        limits:
          cpus: '4'
          memory: 8G
        reservations:
          cpus: '2'
          memory: 4G
```

## Deployment Options

### Option 1: Local Development

Perfect for laptop/desktop use:
```bash
docker-compose up -d
# Access at http://localhost:8080
```

### Option 2: Home Server

Run on a home server with Tailscale:
1. Set up as described above
2. Enable Tailscale
3. Access from anywhere on your Tailscale network

### Option 3: VPS Deployment

Deploy on a cloud VPS (DigitalOcean, Linode, AWS, etc.):

```bash
# On your VPS
git clone https://github.com/mikezhang09-code/my-vscode-server.git
cd my-vscode-server
cp .env.example .env
nano .env  # Configure your settings

# Start the server
docker-compose up -d

# Set up Tailscale for secure access (recommended)
# Or use a reverse proxy with HTTPS (nginx, Caddy)
```

### Option 4: Reverse Proxy with HTTPS

Create `nginx.conf`:
```nginx
server {
    listen 80;
    server_name code.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name code.yourdomain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection upgrade;
        proxy_set_header Accept-Encoding gzip;
    }
}
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker-compose logs

# Check if port is in use
sudo lsof -i :8080

# Try rebuilding
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Cannot Access from Browser

1. Check if container is running:
   ```bash
   docker-compose ps
   ```

2. Check firewall:
   ```bash
   # Linux
   sudo ufw allow 8080
   
   # Or disable temporarily
   sudo ufw disable
   ```

3. Try accessing with container IP:
   ```bash
   docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' vscode-server
   # Access at http://<IP>:8080
   ```

### AI CLI Not Working

```bash
# Enter container
docker-compose exec code-server bash

# Check if API keys are set
env | grep API_KEY

# Reinstall AI tools
bash /opt/ai-tools/setup-scripts/setup-all.sh

# Test each CLI
chatgpt-cli "test"
claude-cli "test"
gemini-cli "test"
```

### Extension Installation Failed

```bash
# Enter container
docker-compose exec code-server bash

# Manually install extension
code-server --install-extension <extension-id>

# Check installed extensions
code-server --list-extensions
```

### Performance Issues

1. Increase Docker resources (Docker Desktop settings)
2. Use SSD for volume mounts
3. Disable unused extensions
4. Clear workspace cache:
   ```bash
   docker-compose exec code-server rm -rf /home/coder/.local/share/code-server/CachedData
   ```

### Tailscale Not Connecting

```bash
# Check Tailscale status
docker-compose exec code-server tailscale status

# Check if tailscaled is running
docker-compose exec code-server pgrep tailscaled

# Restart Tailscale
docker-compose restart

# Check logs
docker-compose logs | grep tailscale
```

## Best Practices

1. **Regular Backups**: Backup your workspace directory regularly
2. **Update Regularly**: Rebuild container monthly for security updates
3. **Use Git**: Keep your code in version control
4. **Secure API Keys**: Never commit `.env` file to version control
5. **Use Strong Passwords**: Set strong passwords for code-server access
6. **Monitor Resources**: Keep an eye on CPU/RAM usage
7. **Use Tailscale**: For secure remote access instead of public exposure

## Getting Help

- **GitHub Issues**: [Report issues](https://github.com/mikezhang09-code/my-vscode-server/issues)
- **Documentation**: Check the main [README.md](README.md)
- **Community**: Ask questions in GitHub Discussions

---

**Enjoy your portable development environment! 🎉**
