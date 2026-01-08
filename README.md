sudo make # My Portable Code Server

A Docker-based, portable VS Code environment accessible via Tailscale.
Pre-configured with **Node.js 20**, **Python**, **Claude Code**, and **Gemini CLI**.

## Prerequisites
- **Docker** & **Docker Compose**
- **Tailscale** (for remote access)

## Quick Start

1.  **Prepare Directories** (Fix permissions):
    ```bash
    mkdir -p data config
    # create config subdirs to persist tool auth
    mkdir -p config/gemini config/claude config/npm
    # Set permissions (User 1000 is 'coder' inside container)
    sudo chown -R 1000:1000 data config
    ```

2.  **Build the Environment**:
    ```bash
    sudo docker compose build
    ```

2.  **Start the Server**:
    ```bash
    sudo docker compose up -d
    ```

3.  **Access**:
    - **Local Access**: `http://localhost:8080`
    - **LAN Access**: `http://<your-lan-ip>:8080` (e.g., `http://192.168.1.100:8080`)
    - **Remote Access (Tailscale)**: `http://<your-tailscale-ip>:8080`
    - **Password**: configured in `docker-compose.yml` (Default: `password`)

*(Optional: If you have `make` installed, you can use `sudo make build` and `sudo make up`)*

## AI Tools
Open the integrated terminal in code-server (Ctrl+`) and run:
- **Claude**: `claude`
- **Gemini**: `gemini`

## Frontend Development (React, Vite, Tailwind)
1.  **Create Project**: `npm create vite@latest my-app -- --template react-ts`
2.  **Install Tailwind**: `npm install -D tailwindcss postcss autoprefixer && npx tailwindcss init -p`
3.  **Run Dev Server**:
    ```bash
    npm run dev -- --host
    ```
    *Note: The `--host` flag is required.*
    *Access at `http://<tailscale-ip>:5173`*

## Configuration
- **Password**: Edit `docker-compose.yml`
- **Ports**:
    - `8080`: Code-server
    - `3000-3010`: Common Dev Servers (React, Next.js)
    - `5173`: Vite
    - `8081-8090`: Additional ports

## Management
- **Stop Server**: `sudo docker compose down`
- **View Logs**: `sudo docker compose logs -f`
- **Shell Access**: `sudo docker compose exec dev-server bash`

## Troubleshooting

### 1. "npm run dev" opens localhost:8081 (Browser Issue)
- **Fix**: We've set `BROWSER=none` in `docker-compose.yml`. This prevents the container from trying to open a GUI browser.
- **Access**: Use the forwarded ports. For `8081`, go to `http://<tailscale-ip>:8081`.

### 2. Authorization (Localhost callback failed)
- **Context**: Since the browser is on your VPS (or client) and the container is remote, `localhost` callbacks won't reach the container.
- **Fix**: When authenticating (e.g. `gh auth login`, `wrangler login`), choose **"Paste an authentication token"** or **"Device Code"** flow if available.
- **Note**: `BROWSER=none` usually forces these tools to offer a copy-paste link.

### 3. GitHub Copilot Configuration
- **Issue**: Copilot is not enabled by default in open-source `code-server`.
- **Fix**: We have configured `EXTENSIONS_GALLERY` to point to the Microsoft Marketplace in `docker-compose.yml`.
- **Action**: Restart the server (`make down && make up`), then search for "GitHub Copilot" in the Extensions view and install it normally.
