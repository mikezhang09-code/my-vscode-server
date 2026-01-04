#!/bin/bash
# Setup script for Gemini CLI

set -e

echo "Setting up Gemini CLI..."

# Check if GOOGLE_API_KEY or GEMINI_API_KEY is set
if [ -z "$GOOGLE_API_KEY" ] && [ -z "$GEMINI_API_KEY" ]; then
    echo "Error: GOOGLE_API_KEY or GEMINI_API_KEY environment variable is not set"
    echo "Please set your API key in the .env file"
    exit 1
fi

# Install Google Generative AI SDK for Python
echo "Installing Google Generative AI SDK..."
pip3 install --user google-generativeai

# Create a simple CLI wrapper script
cat > ~/.local/bin/gemini-cli << 'EOF'
#!/usr/bin/env python3
import os
import sys
import google.generativeai as genai

def main():
    api_key = os.environ.get('GOOGLE_API_KEY') or os.environ.get('GEMINI_API_KEY')
    if not api_key:
        print("Error: GOOGLE_API_KEY or GEMINI_API_KEY not set", file=sys.stderr)
        sys.exit(1)
    
    genai.configure(api_key=api_key)
    model = genai.GenerativeModel('gemini-pro')
    
    if len(sys.argv) < 2:
        print("Usage: gemini-cli <prompt>")
        sys.exit(1)
    
    prompt = ' '.join(sys.argv[1:])
    
    try:
        response = model.generate_content(prompt)
        print(response.text)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
EOF

chmod +x ~/.local/bin/gemini-cli

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

echo "Gemini CLI setup complete!"
echo "Usage: gemini-cli <your prompt>"
echo "Example: gemini-cli 'Write a Python function to sort a list'"
