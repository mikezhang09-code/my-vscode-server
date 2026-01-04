#!/bin/bash
# Master setup script to install all AI CLI tools

set -e

echo "=========================================="
echo "Setting up AI CLI Tools"
echo "=========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make scripts executable
chmod +x "$SCRIPT_DIR"/*.sh

# Create .local/bin if it doesn't exist
mkdir -p ~/.local/bin

# Setup ChatGPT CLI
if [ -n "$OPENAI_API_KEY" ]; then
    echo ""
    echo "Setting up ChatGPT CLI..."
    bash "$SCRIPT_DIR/setup-chatgpt-cli.sh" || echo "ChatGPT CLI setup failed"
else
    echo "Skipping ChatGPT CLI (OPENAI_API_KEY not set)"
fi

# Setup Claude CLI
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo ""
    echo "Setting up Claude CLI..."
    bash "$SCRIPT_DIR/setup-claude-cli.sh" || echo "Claude CLI setup failed"
else
    echo "Skipping Claude CLI (ANTHROPIC_API_KEY not set)"
fi

# Setup Gemini CLI
if [ -n "$GOOGLE_API_KEY" ] || [ -n "$GEMINI_API_KEY" ]; then
    echo ""
    echo "Setting up Gemini CLI..."
    bash "$SCRIPT_DIR/setup-gemini-cli.sh" || echo "Gemini CLI setup failed"
else
    echo "Skipping Gemini CLI (GOOGLE_API_KEY/GEMINI_API_KEY not set)"
fi

echo ""
echo "=========================================="
echo "AI CLI Tools Setup Complete!"
echo "=========================================="
echo ""
echo "Available commands (if API keys were configured):"
echo "  - chatgpt-cli <prompt>"
echo "  - claude-cli <prompt>"
echo "  - gemini-cli <prompt>"
echo ""
echo "Note: You may need to restart your shell or run:"
echo "  source ~/.bashrc"
echo ""
