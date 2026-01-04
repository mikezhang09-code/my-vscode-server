# Testing and Verification Guide

This guide helps you test and verify that your VS Code Server setup is working correctly.

## Quick Test Checklist

- [ ] Docker build completes successfully
- [ ] Container starts and stays running
- [ ] Code-server is accessible via browser
- [ ] Password authentication works
- [ ] VS Code extensions are installed
- [ ] Language support works (Node.js, Python, Go, Rust, Java)
- [ ] AI CLI tools are functional (if API keys configured)
- [ ] Tailscale connection works (if configured)

## Step-by-Step Testing

### 1. Test Docker Build

```bash
# Build the image
docker compose build

# Expected: Build completes without errors
# Time: 10-20 minutes depending on internet speed
```

### 2. Test Container Startup

```bash
# Start the container
docker compose up -d

# Check if container is running
docker compose ps

# Expected output should show:
# NAME              COMMAND                  SERVICE         STATUS          PORTS
# vscode-server     "/usr/bin/entrypoint…"   code-server     Up 10 seconds   0.0.0.0:8080->8080/tcp

# Check logs
docker compose logs

# Expected: No error messages, should see "HTTP server listening on http://0.0.0.0:8080"
```

### 3. Test Web Access

1. Open browser: `http://localhost:8080`
2. Enter password from `.env` file
3. Expected: VS Code interface loads

### 4. Test Language Support

#### Test Node.js/JavaScript

```bash
# Access container
docker compose exec code-server bash

# Test Node.js
node --version
npm --version

# Create and run a test file
cd ~/workspace
cat > test.js << 'EOF'
console.log("Hello from Node.js!");
const sum = (a, b) => a + b;
console.log("2 + 3 =", sum(2, 3));
EOF

node test.js
# Expected: "Hello from Node.js!" and "2 + 3 = 5"
```

#### Test Python

```bash
# Test Python
python3 --version
pip3 --version

# Create and run a test file
cat > test.py << 'EOF'
print("Hello from Python!")
numbers = [1, 2, 3, 4, 5]
print("Sum:", sum(numbers))
EOF

python3 test.py
# Expected: "Hello from Python!" and "Sum: 15"
```

#### Test Go

```bash
# Test Go
go version

# Create and run a test file
cat > test.go << 'EOF'
package main
import "fmt"

func main() {
    fmt.Println("Hello from Go!")
    sum := 2 + 3
    fmt.Printf("2 + 3 = %d\n", sum)
}
EOF

go run test.go
# Expected: "Hello from Go!" and "2 + 3 = 5"
```

#### Test Rust

```bash
# Test Rust
rustc --version
cargo --version

# Create a simple Rust project
cargo new hello_rust
cd hello_rust
cargo run
# Expected: "Hello, world!"
```

#### Test Java

```bash
# Test Java
java --version
javac --version

# Create and run a test file
cat > Test.java << 'EOF'
public class Test {
    public static void main(String[] args) {
        System.out.println("Hello from Java!");
        int sum = 2 + 3;
        System.out.println("2 + 3 = " + sum);
    }
}
EOF

javac Test.java
java Test
# Expected: "Hello from Java!" and "2 + 3 = 5"
```

### 5. Test VS Code Extensions

1. In VS Code web interface, press `Ctrl+Shift+X` to open Extensions
2. Check if these extensions are installed:
   - Python
   - Go
   - Rust Analyzer
   - Java Extension Pack
   - ESLint
   - Prettier
   - GitHub Copilot (if you have a subscription)
   - Continue

### 6. Test AI CLI Tools

#### Test ChatGPT CLI (if configured)

```bash
# Make sure you're in the container
docker compose exec code-server bash

# Test ChatGPT CLI
chatgpt-cli "Say hello and tell me today's date format"

# Expected: A response from ChatGPT
```

#### Test Claude CLI (if configured)

```bash
claude-cli "What is 2 + 2?"

# Expected: A response from Claude
```

#### Test Gemini CLI (if configured)

```bash
gemini-cli "What is Docker in one sentence?"

# Expected: A response from Gemini
```

### 7. Test Tailscale (if configured)

```bash
# Check Tailscale status
docker compose exec code-server tailscale status

# Get your Tailscale IP
docker compose exec code-server tailscale ip -4

# Expected: Shows IP like 100.x.x.x and status information
```

Access from another device on Tailscale network:
```
http://100.x.x.x:8080
```

### 8. Test Docker-in-Docker

```bash
# Inside container
docker compose exec code-server bash

# Test Docker CLI
docker --version

# Try pulling an image
docker pull hello-world
docker run hello-world

# Expected: Hello World message from Docker
```

### 9. Test Development Workflow

1. Create a new project in workspace
2. Install dependencies (npm install, pip install, etc.)
3. Run the project
4. Use AI assistant to help with code
5. Commit changes with git

Example Node.js project:

```bash
# Inside container
cd ~/workspace
mkdir my-test-app
cd my-test-app
npm init -y
npm install express

cat > app.js << 'EOF'
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello World from VS Code Server!');
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
EOF

node app.js
# In another terminal: curl http://localhost:3000
# Expected: "Hello World from VS Code Server!"
```

## Common Issues and Solutions

### Build Fails

**Issue**: Docker build fails with network errors
**Solution**: 
- Check internet connection
- Try again with `docker compose build --no-cache`
- Check if any firewall is blocking Docker

### Container Exits Immediately

**Issue**: Container starts but exits right away
**Solution**:
```bash
# Check logs for errors
docker compose logs

# Common issues:
# - Invalid .env configuration
# - Port 8080 already in use
# - Insufficient resources
```

### Cannot Access Port 8080

**Issue**: Browser can't connect to localhost:8080
**Solution**:
```bash
# Check if port is mapped correctly
docker compose ps

# Check if something else is using port 8080
sudo lsof -i :8080

# Try accessing container directly
docker inspect vscode-server | grep IPAddress
# Then access http://<container-ip>:8080
```

### AI CLI Tools Not Working

**Issue**: AI CLI commands not found
**Solution**:
```bash
# Enter container
docker compose exec code-server bash

# Check if PATH includes ~/.local/bin
echo $PATH

# Add to PATH if needed
export PATH="$HOME/.local/bin:$PATH"

# Re-run setup
bash /opt/ai-tools/setup-scripts/setup-all.sh

# Source bashrc
source ~/.bashrc
```

### Extensions Not Installed

**Issue**: VS Code extensions are missing
**Solution**:
```bash
# Enter container
docker compose exec code-server bash

# List installed extensions
code-server --list-extensions

# Manually install missing extension
code-server --install-extension <extension-id>

# Rebuild container if needed
docker compose down
docker compose build --no-cache
docker compose up -d
```

### Tailscale Not Working

**Issue**: Cannot connect via Tailscale
**Solution**:
```bash
# Check if Tailscale is running
docker compose exec code-server pgrep tailscaled

# Check status
docker compose exec code-server tailscale status

# Check if auth key is valid
# - Go to Tailscale admin console
# - Verify key hasn't expired
# - Generate new key if needed

# Restart container
docker compose restart
```

## Performance Testing

### Check Resource Usage

```bash
# Check container stats
docker stats vscode-server

# Expected:
# - CPU: Should be low when idle (<5%)
# - Memory: 500MB - 2GB depending on usage
# - Network: Varies with activity
```

### Load Testing

1. Open multiple large files
2. Run a build process
3. Use AI assistant
4. Monitor performance

```bash
# Inside container
top
# or
htop
```

## Security Testing

### Verify Password Protection

1. Try accessing without password
2. Try wrong password
3. Verify password is required

### Verify API Keys are Not Exposed

```bash
# Inside container
docker compose exec code-server bash

# Check environment variables are set
env | grep API_KEY

# Verify .env is not committed
git status
# .env should not be listed
```

### Verify Tailscale Encryption

```bash
# Check Tailscale connection
docker compose exec code-server tailscale status

# Verify encryption is enabled
docker compose exec code-server tailscale status --json | grep -i encrypt
```

## Success Criteria

Your setup is working correctly if:

✅ Container builds and starts without errors  
✅ Web interface is accessible and responsive  
✅ All language runtimes work (Node.js, Python, Go, Rust, Java)  
✅ VS Code extensions are installed and functional  
✅ AI CLI tools work (if API keys configured)  
✅ Tailscale connection works (if configured)  
✅ Password authentication protects access  
✅ Workspace data persists after container restart  
✅ Resource usage is reasonable  

## Next Steps

Once all tests pass:

1. **Backup your configuration**: Save your `.env` file securely
2. **Set up regular backups**: Configure backup for workspace directory
3. **Configure git**: Set up git credentials in the container
4. **Customize VS Code**: Install additional extensions as needed
5. **Set up projects**: Clone your repositories and start coding!

## Getting Help

If you encounter issues not covered here:

1. Check the logs: `docker compose logs`
2. Review [SETUP-GUIDE.md](SETUP-GUIDE.md)
3. Search for similar issues on GitHub
4. Open a new issue with:
   - Error messages
   - Steps to reproduce
   - Your environment (OS, Docker version)
   - Relevant logs

---

**Happy Testing! 🧪**
