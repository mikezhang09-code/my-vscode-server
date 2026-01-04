#!/bin/bash
# Startup script to initialize code-server with all services

set -e

echo "Starting Code-Server with Tailscale support..."

# Check if Tailscale should be started
if [ -n "$TAILSCALE_AUTH_KEY" ]; then
    echo "Starting Tailscale..."
    # Start tailscaled in background
    sudo tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
    
    # Wait for tailscaled to be ready
    sleep 2
    
    # Authenticate with Tailscale
    sudo tailscale up --authkey="$TAILSCALE_AUTH_KEY" --hostname="vscode-server"
    
    echo "Tailscale started successfully!"
    echo "Your Tailscale IP:"
    tailscale ip -4
else
    echo "Tailscale auth key not provided. Skipping Tailscale setup."
    echo "Set TAILSCALE_AUTH_KEY in .env file to enable Tailscale."
fi

# Setup AI CLI tools if API keys are available
if [ -f /opt/ai-tools/setup-scripts/setup-all.sh ]; then
    echo ""
    echo "Setting up AI CLI tools..."
    bash /opt/ai-tools/setup-scripts/setup-all.sh
fi

# Start code-server
echo ""
echo "Starting code-server..."
exec code-server --bind-addr 0.0.0.0:8080 /home/coder/workspace
