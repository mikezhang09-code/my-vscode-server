sudo make # My Portable Code Server

A Docker-based, portable VS Code environment accessible via Tailscale.
Pre-configured with **Node.js 20**, **Python**, **Claude Code**, and **Gemini CLI**.

## Prerequisites
- **Docker** & **Docker Compose**
- **Tailscale** (for remote access)

## Quick Start

1.  **Build the Environment**:
    ```bash
    sudo docker compose build
    ```

2.  **Start the Server**:
    ```bash
    sudo docker compose up -d
    ```

3.  **Access**:
    - URL: `http://<your-tailscale-ip>:8080` (or `http://localhost:8080`)
    - Password: configured in `docker-compose.yml` (Default: `password`)

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
    - `5173`: Vite default (Ensure this is exposed in `docker-compose.yml` or use VS Code port forwarding).

## Management
- **Stop Server**: `sudo docker compose down`
- **View Logs**: `sudo docker compose logs -f`
- **Shell Access**: `sudo docker compose exec dev-server bash`
