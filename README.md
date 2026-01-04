# My VS Code Server

A complete development environment setup with code-server (VS Code in the browser), supporting multiple programming languages and AI assistants, accessible anywhere via Tailscale.

## Features

- 🌐 **Remote Access**: Access VS Code from anywhere via browser with Tailscale integration
- 🖥️ **Multi-Language Support**: Pre-configured support for:
  - Node.js / JavaScript / TypeScript
  - Python 3
  - Go
  - Rust
  - Java
- 🤖 **AI Assistants**: Integrated CLI tools for:
  - ChatGPT (OpenAI)
  - Claude (Anthropic)
  - Gemini (Google)
  - GitHub Copilot extension support
  - Continue.dev extension for local AI
- 🔧 **Development Tools**: Includes Docker CLI, common build tools, linters, and formatters
- 📦 **Containerized**: Everything runs in Docker for consistency and portability
- 🔒 **Secure**: Password-protected access with optional Tailscale VPN

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- (Optional) Tailscale account for remote access
- (Optional) API keys for AI assistants

### Installation

1. **Clone this repository**:
   ```bash
   git clone https://github.com/mikezhang09-code/my-vscode-server.git
   cd my-vscode-server
   ```

2. **Configure environment variables**:
   ```bash
   cp .env.example .env
   # Edit .env with your preferred text editor
   nano .env
   ```

   Minimum configuration required:
   - `CODE_SERVER_PASSWORD`: Set a secure password for accessing code-server

3. **Start the server**:
   ```bash
   ./quick-start.sh
   ```
   
   Or manually:
   ```bash
   docker compose up -d
   # Note: Older Docker versions may require: docker-compose up -d
   ```

4. **Access your code-server**:
   - Open your browser and navigate to: `http://localhost:8080`
   - Enter the password you configured in `.env`

5. **Verify the setup** (optional but recommended):
   - See [TESTING.md](TESTING.md) for comprehensive testing instructions

## Configuration

### Basic Setup

Edit the `.env` file to configure:

```bash
# Code Server Configuration
CODE_SERVER_PASSWORD=your-secure-password-here
SUDO_PASSWORD=your-sudo-password-here
```

### Tailscale Setup (Optional but Recommended)

For secure remote access:

1. **Get a Tailscale auth key**:
   - Sign up at [https://tailscale.com](https://tailscale.com)
   - Go to Settings > Keys
   - Generate an auth key (optionally reusable and non-expiring)

2. **Add to your `.env` file**:
   ```bash
   TAILSCALE_AUTH_KEY=tskey-auth-xxxxx
   ```

3. **Enable host network mode** in `docker-compose.yml`:
   ```yaml
   services:
     code-server:
       network_mode: host  # Uncomment this line
       # ports:            # Comment out ports section
       #   - "8080:8080"
   ```

4. **Restart the container**:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

5. **Access via Tailscale**:
   - Your code-server will be accessible at: `http://<tailscale-ip>:8080`
   - Find your Tailscale IP with: `docker-compose exec code-server tailscale ip -4`

### AI Assistants Setup

#### ChatGPT (OpenAI)

1. Get an API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Add to `.env`:
   ```bash
   OPENAI_API_KEY=sk-xxxxx
   ```
3. Inside the container or after setup, use:
   ```bash
   chatgpt-cli "Your question here"
   ```

#### Claude (Anthropic)

1. Get an API key from [Anthropic Console](https://console.anthropic.com/)
2. Add to `.env`:
   ```bash
   ANTHROPIC_API_KEY=sk-ant-xxxxx
   ```
3. Use the CLI:
   ```bash
   claude-cli "Your question here"
   ```

#### Gemini (Google)

1. Get an API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Add to `.env`:
   ```bash
   GOOGLE_API_KEY=xxxxx
   # or
   GEMINI_API_KEY=xxxxx
   ```
3. Use the CLI:
   ```bash
   gemini-cli "Your question here"
   ```

#### GitHub Copilot

1. Subscribe to [GitHub Copilot](https://github.com/features/copilot)
2. Inside code-server:
   - Open Command Palette (F1)
   - Type "GitHub Copilot: Sign In"
   - Follow the authentication flow

#### Cursor / Continue.dev

- **Continue.dev** extension is pre-installed
- Configure it in VS Code settings to use your preferred AI model
- Supports OpenAI, Anthropic, local models, and more

For **Cursor**, it's a separate VS Code fork. Since we're using code-server, we can't directly use Cursor, but Continue.dev provides similar functionality.

## Language Support

The following languages and tools are pre-installed:

### Node.js / JavaScript / TypeScript
- Node.js (LTS version)
- npm, yarn, pnpm
- TypeScript, ts-node
- ESLint extension
- Prettier extension

### Python
- Python 3
- pip, venv
- Common packages: pylint, black, flake8, pytest, numpy, pandas
- Python extension for VS Code

### Go
- Go 1.21.5
- Go extension for VS Code
- GOPATH configured

### Rust
- Rust (latest stable via rustup)
- rust-analyzer extension

### Java
- OpenJDK 17
- Maven
- Gradle
- Java Pack extension

### Docker
- Docker CLI (for Docker-in-Docker support)
- Docker socket mounted by default

## Project Structure

```
my-vscode-server/
├── Dockerfile              # Container image definition
├── docker-compose.yml      # Docker Compose configuration
├── .env.example           # Environment variables template
├── .gitignore             # Git ignore rules
├── start.sh               # Container startup script
├── quick-start.sh         # Quick start helper script
├── README.md              # This file
├── SETUP-GUIDE.md         # Detailed setup guide
├── TESTING.md             # Testing and verification guide
├── LICENSE                # MIT License
├── config/                # Code-server configuration
│   ├── config.yaml        # Code-server settings (generated)
│   └── settings.json      # VS Code settings
├── setup-scripts/         # AI CLI setup scripts
│   ├── setup-all.sh
│   ├── setup-chatgpt-cli.sh
│   ├── setup-claude-cli.sh
│   └── setup-gemini-cli.sh
├── workspace/             # Your code goes here (persisted)
└── vscode-data/           # VS Code data (persisted)
```

## Usage

### Starting the Server
```bash
docker compose up -d
# Note: Older Docker versions may require: docker-compose up -d
```

### Stopping the Server
```bash
docker compose down
```

### Viewing Logs
```bash
docker compose logs -f
```

### Accessing the Container Shell
```bash
docker compose exec code-server bash
```

### Rebuilding After Changes
```bash
docker compose build --no-cache
docker compose up -d
```

## AI CLI Tools Usage

Once your API keys are configured, you can use AI assistants from the terminal:

### ChatGPT
```bash
chatgpt-cli "Explain what a Docker container is"
chatgpt-cli "Write a Python function to calculate fibonacci numbers"
```

### Claude
```bash
claude-cli "Help me debug this Python error: TypeError: 'NoneType' object is not subscriptable"
claude-cli "Review this code and suggest improvements: [paste code]"
```

### Gemini
```bash
gemini-cli "What are the best practices for writing Go code?"
gemini-cli "Explain the differences between React and Vue.js"
```

## Customization

### Adding More Languages

Edit the `Dockerfile` to add more languages or tools. For example, to add PHP:

```dockerfile
RUN apt-get update && apt-get install -y \
    php \
    php-cli \
    composer \
    && rm -rf /var/lib/apt/lists/*
```

### Adding VS Code Extensions

Add extension installation commands to the Dockerfile:

```dockerfile
RUN code-server --install-extension <publisher>.<extension-name>
```

Find extension IDs on the [VS Code Marketplace](https://marketplace.visualstudio.com/vscode).

### Custom VS Code Settings

Edit `config/settings.json` to customize VS Code settings. Changes will be applied on container restart.

## Troubleshooting

### Cannot access code-server

- Check if the container is running: `docker compose ps`
- Check logs: `docker compose logs code-server`
- Verify port 8080 is not in use: `sudo lsof -i :8080`

### Tailscale not connecting

- Verify your auth key is valid
- Check if the container has network privileges: `privileged: true` and proper `cap_add` in docker-compose.yml
- Check Tailscale logs: `docker compose exec code-server tailscale status`

### AI CLI tools not working

- Verify API keys are set in `.env`
- Check if environment variables are loaded: `docker compose exec code-server env | grep API_KEY`
- Re-run setup: `docker compose exec code-server bash /opt/ai-tools/setup-scripts/setup-all.sh`

### Permission issues

- If you encounter permission issues with volumes, adjust ownership:
  ```bash
  sudo chown -R 1000:1000 workspace vscode-data config
  ```

## Security Considerations

1. **Change default passwords**: Always set strong passwords in `.env`
2. **Keep API keys secret**: Never commit `.env` to version control
3. **Use Tailscale**: For secure remote access instead of exposing ports publicly
4. **Regular updates**: Rebuild the container periodically to get security updates
5. **Network security**: If not using Tailscale, use a firewall or reverse proxy with HTTPS

## Performance Tips

1. **Mount specific directories**: Instead of mounting entire home directory, mount only what you need
2. **Use volumes for data**: Docker volumes are faster than bind mounts on Mac/Windows
3. **Resource limits**: Adjust Docker resource limits based on your needs
4. **Disable unused extensions**: Disable VS Code extensions you don't use

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - feel free to use this for your own projects!

## Support

For issues and questions:
- Open an issue on GitHub
- Check the [SETUP-GUIDE.md](SETUP-GUIDE.md) for detailed instructions
- Review [TESTING.md](TESTING.md) for verification and troubleshooting

## Acknowledgments

- [code-server](https://github.com/coder/code-server) by Coder
- [Tailscale](https://tailscale.com/) for secure networking
- All the AI assistant providers: OpenAI, Anthropic, Google
- The VS Code extension authors

---

**Happy Coding from Anywhere! 🚀**
