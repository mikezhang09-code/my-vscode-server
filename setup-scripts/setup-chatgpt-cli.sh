#!/bin/bash
# Setup script for ChatGPT CLI (OpenAI)

set -e

echo "Setting up ChatGPT CLI..."

# Check if OPENAI_API_KEY is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY environment variable is not set"
    echo "Please set your API key in the .env file"
    exit 1
fi

# Install OpenAI SDK for Python
echo "Installing OpenAI SDK..."
pip3 install --user openai

# Create a simple CLI wrapper script
cat > ~/.local/bin/chatgpt-cli << 'EOF'
#!/usr/bin/env python3
import os
import sys
from openai import OpenAI

def main():
    api_key = os.environ.get('OPENAI_API_KEY')
    if not api_key:
        print("Error: OPENAI_API_KEY not set", file=sys.stderr)
        sys.exit(1)
    
    if len(sys.argv) < 2:
        print("Usage: chatgpt-cli <prompt>")
        sys.exit(1)
    
    prompt = ' '.join(sys.argv[1:])
    
    try:
        client = OpenAI(api_key=api_key)
        response = client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "user", "content": prompt}
            ]
        )
        print(response.choices[0].message.content)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
EOF

chmod +x ~/.local/bin/chatgpt-cli

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

echo "ChatGPT CLI setup complete!"
echo "Usage: chatgpt-cli <your prompt>"
echo "Example: chatgpt-cli 'Explain what Docker is'"
