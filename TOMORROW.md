# Tomorrow: Codex OAuth callback fix (VPS + code-server)

## Goal
Get OpenAI Codex (VS Code extension inside code-server) authorization working when the container runs on a VPS and the browser is on a laptop.

## Current state
- `docker-compose.yml` publishes `1445:1445` and `1455:1455`.
- Codex auth redirect attempts to hit `http://localhost:1445/...`.

## Key concept
`localhost` in the redirect URL refers to the machine running the browser.
- If you authenticate from your laptop browser, `localhost:1445` is your laptop.
- The callback listener is inside the VPS container, so you must bridge laptop `localhost:1445` -> VPS `127.0.0.1:1445`.

## Step 1: Recreate container (VPS)
On the VPS (where docker runs):

```bash
sudo docker compose down
sudo docker compose up -d
```

## Step 2: Create a tunnel (Laptop)
On your laptop, run:

```bash
ssh -N -L 1445:127.0.0.1:1445 <user>@<vps-host>
```

Notes:
- Use the VPS Tailscale IP as `<vps-host>` if you normally access via Tailscale.
- Keep this SSH session running during the auth flow.

## Step 3: Retry Codex sign-in
- In code-server, trigger Codex login again.
- The browser should open `http://localhost:1445/...` and it should now reach the VPS via the SSH tunnel.

## Troubleshooting checklist
1. Port published on VPS:

```bash
sudo docker compose ps
sudo docker port my-code-server | grep 1445
```

2. While the auth flow is active, see if something is listening in the container:

```bash
sudo docker compose exec dev-server sh -lc "ss -ltnp | grep 1445 || true"
```

3. If the container process listens only on `127.0.0.1:1445` (loopback inside container), Docker publishing won’t help. In that case we need either:
- a way to force the Codex callback server to bind `0.0.0.0`, or
- a reverse proxy/tunnel approach, or
- avoid callback flow (device code / token copy) if supported.

## What to capture if it still fails
- The exact URL opened by the login flow (redact tokens).
- Any Codex extension logs from code-server (Output panel / logs).
- Output of the `ss -ltnp | grep 1445` command above during the login attempt.
