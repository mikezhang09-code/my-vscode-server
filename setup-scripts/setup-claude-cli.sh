#!/bin/bash
# Setup script for Claude CLI (Anthropic)

set -e

echo "Setting up Claude CLI..."

# Check if ANTHROPIC_API_KEY is set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Error: ANTHROPIC_API_KEY environment variable is not set"
    echo "Please set your API key in the .env file"
    exit 1
fi

# Install Anthropic SDK for Python
echo "Installing Anthropic SDK..."
pip3 install --user anthropic

# Create a simple CLI wrapper script
cat > ~/.local/bin/claude-cli << 'EOF'
#!/usr/bin/env python3
import os
import sys
from anthropic import Anthropic

def main():
    api_key = os.environ.get('ANTHROPIC_API_KEY')
    if not api_key:
        print("Error: ANTHROPIC_API_KEY not set", file=sys.stderr)
        sys.exit(1)
    
    if len(sys.argv) < 2:
        print("Usage: claude-cli <prompt>")
        sys.exit(1)
    
    prompt = ' '.join(sys.argv[1:])
    
    try:
        client = Anthropic(api_key=api_key)
        message = client.messages.create(
            model="claude-3-5-sonnet-20241022",
            max_tokens=1024,
            messages=[
                {"role": "user", "content": prompt}
            ]
        )
        print(message.content[0].text)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
EOF

chmod +x ~/.local/bin/claude-cli

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

echo "Claude CLI setup complete!"
echo "Usage: claude-cli <your prompt>"
echo "Example: claude-cli 'Write a Python function to reverse a string'"
