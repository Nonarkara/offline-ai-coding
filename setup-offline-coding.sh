#!/bin/bash
# ============================================================================
# SPDX-License-Identifier: MIT
# OFF-THE-GRID CODING SETUP
# Complete offline AI coding environment for Apple Silicon Mac
# ============================================================================
# Run this script with: bash setup-offline-coding.sh
# It will install everything you need, step by step.
# ============================================================================

set -e

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${BLUE}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# ============================================================================
# STEP 0: Detect system
# ============================================================================
print_header "DETECTING YOUR SYSTEM"

# Check we're on macOS ARM
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This script is designed for macOS. Detected: $(uname)"
    exit 1
fi

ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
    print_error "This script is designed for Apple Silicon (arm64). Detected: $ARCH"
    exit 1
fi

# Detect RAM
RAM_BYTES=$(sysctl -n hw.memsize)
RAM_GB=$((RAM_BYTES / 1073741824))
print_step "macOS on Apple Silicon detected"
print_step "RAM: ${RAM_GB}GB"

# Determine which models to install based on RAM
if [ "$RAM_GB" -ge 64 ]; then
    RAM_TIER="64gb"
    CHAT_MODEL="qwen2.5-coder:32b"
    COMPLETION_MODEL="qwen2.5-coder:7b"
    print_info "64GB+ RAM — You get the full experience: 32B chat + 7B autocomplete"
elif [ "$RAM_GB" -ge 32 ]; then
    RAM_TIER="32gb"
    CHAT_MODEL="qwen2.5-coder:32b"
    COMPLETION_MODEL="qwen2.5-coder:7b"
    print_info "32GB RAM — Great setup: 32B chat + 7B autocomplete"
elif [ "$RAM_GB" -ge 16 ]; then
    RAM_TIER="16gb"
    CHAT_MODEL="qwen2.5-coder:14b"
    COMPLETION_MODEL="qwen2.5-coder:3b"
    print_info "16GB RAM — Solid setup: 14B chat + 3B autocomplete"
else
    RAM_TIER="8gb"
    CHAT_MODEL="qwen2.5-coder:7b"
    COMPLETION_MODEL="qwen2.5-coder:1.5b"
    print_info "8GB RAM — Lightweight setup: 7B chat + 1.5B autocomplete"
fi

echo ""
print_info "Selected models:"
print_info "  Chat/Agent model:      $CHAT_MODEL"
print_info "  Autocomplete model:    $COMPLETION_MODEL"
echo ""

# ============================================================================
# STEP 1: Install Homebrew (if needed)
# ============================================================================
print_header "STEP 1: HOMEBREW (Package Manager)"

if command -v brew &> /dev/null; then
    print_step "Homebrew already installed"
else
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Add to shell profile
    if [ -f "$HOME/.zprofile" ]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    else
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    fi
    print_step "Homebrew installed"
fi

# ============================================================================
# STEP 2: Install Ollama
# ============================================================================
print_header "STEP 2: OLLAMA (Local LLM Engine)"

if command -v ollama &> /dev/null; then
    print_step "Ollama already installed"
    print_info "Checking for updates..."
    brew upgrade ollama 2>/dev/null || true
else
    print_info "Installing Ollama..."
    brew install ollama
    print_step "Ollama installed"
fi

# Start Ollama service
print_info "Starting Ollama service..."
if pgrep -x "ollama" > /dev/null; then
    print_step "Ollama is already running"
else
    brew services start ollama 2>/dev/null || ollama serve &>/dev/null &
    sleep 5
    if pgrep -x "ollama" > /dev/null; then
        print_step "Ollama service started"
    else
        print_error "Ollama didn't start. Try running 'ollama serve' manually in another terminal."
    fi
fi

# ============================================================================
# STEP 3: Download AI Models (this takes a while)
# ============================================================================
print_header "STEP 3: DOWNLOADING AI MODELS"
print_warn "This will download several GB of model data (10-20GB+ depending on your RAM tier)."
print_warn "Make sure you're on a good internet connection and have enough disk space."
print_warn "You only need to do this ONCE — after this, everything works offline."
DISK_FREE=$(df -g "$HOME" 2>/dev/null | tail -1 | awk '{print $4}')
if [ -n "$DISK_FREE" ] && [ "$DISK_FREE" -lt 30 ]; then
    print_warn "You have ${DISK_FREE}GB free disk space. Models need ~20GB. Consider freeing space."
fi
echo ""

# Pull the chat model
print_info "Downloading $CHAT_MODEL (main coding brain)..."
print_info "This is the big one — might take 10-30 minutes depending on your connection."
ollama pull "$CHAT_MODEL"
print_step "$CHAT_MODEL downloaded"

# Pull the autocomplete model
print_info "Downloading $COMPLETION_MODEL (fast autocomplete)..."
ollama pull "$COMPLETION_MODEL"
print_step "$COMPLETION_MODEL downloaded"

# Also pull a general-purpose reasoning model
print_info "Downloading a reasoning model for complex problems..."
if [ "$RAM_GB" -ge 32 ]; then
    REASONING_MODEL="deepseek-r1:14b"
else
    REASONING_MODEL="deepseek-r1:7b"
fi
ollama pull "$REASONING_MODEL"
print_step "$REASONING_MODEL downloaded"

# ============================================================================
# STEP 4: Install VS Code (if needed)
# ============================================================================
print_header "STEP 4: VS CODE (Code Editor)"

if command -v code &> /dev/null; then
    print_step "VS Code already installed"
elif [ -d "/Applications/Visual Studio Code.app" ]; then
    print_step "VS Code app found"
    print_info "Adding 'code' command to PATH..."
    cat << 'SHELLCMD' >> "$HOME/.zprofile"
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
SHELLCMD
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    print_step "'code' command available"
elif command -v cursor &> /dev/null || [ -d "/Applications/Cursor.app" ]; then
    print_step "Cursor (VS Code fork) detected — that works too!"
else
    print_info "Installing VS Code..."
    brew install --cask visual-studio-code
    print_step "VS Code installed"
fi

# ============================================================================
# STEP 5: Install Continue.dev Extension
# ============================================================================
print_header "STEP 5: CONTINUE.DEV (AI Integration for VS Code)"

if command -v code &> /dev/null; then
    print_info "Installing Continue extension..."
    code --install-extension Continue.continue 2>/dev/null || true
    print_step "Continue extension installed"
else
    print_warn "Install Continue extension manually:"
    print_warn "  1. Open VS Code"
    print_warn "  2. Press Cmd+Shift+X (Extensions)"
    print_warn "  3. Search 'Continue'"
    print_warn "  4. Click Install"
fi

# ============================================================================
# STEP 6: Configure Continue.dev for Offline Use
# ============================================================================
print_header "STEP 6: CONFIGURING CONTINUE.DEV"

CONTINUE_DIR="$HOME/.continue"
mkdir -p "$CONTINUE_DIR"

# Write the Continue configuration
cat > "$CONTINUE_DIR/config.json" << CONTINUECONFIG
{
  "models": [
    {
      "title": "Qwen Coder (Offline Chat)",
      "provider": "ollama",
      "model": "$CHAT_MODEL",
      "apiBase": "http://localhost:11434",
      "contextLength": 32768
    },
    {
      "title": "DeepSeek R1 (Reasoning)",
      "provider": "ollama",
      "model": "$REASONING_MODEL",
      "apiBase": "http://localhost:11434",
      "contextLength": 32768
    }
  ],
  "tabAutocompleteModel": {
    "title": "Qwen Coder (Fast Autocomplete)",
    "provider": "ollama",
    "model": "$COMPLETION_MODEL",
    "apiBase": "http://localhost:11434"
  },
  "allowAnonymousTelemetry": false,
  "docs": []
}
CONTINUECONFIG

print_step "Continue.dev configured for offline use"
print_info "Chat model: $CHAT_MODEL"
print_info "Autocomplete model: $COMPLETION_MODEL"
print_info "Reasoning model: $REASONING_MODEL"

# ============================================================================
# STEP 7: Install Aider (Terminal Coding Agent)
# ============================================================================
print_header "STEP 7: AIDER (Terminal Coding Agent — like Claude Code)"

if command -v python3 &> /dev/null; then
    print_info "Installing Aider..."
    python3 -m pip install aider-chat --break-system-packages 2>/dev/null || \
    python3 -m pip install aider-chat --user 2>/dev/null || \
    brew install aider 2>/dev/null || true
    print_step "Aider installed"
else
    print_info "Installing Python first..."
    brew install python3
    python3 -m pip install aider-chat --break-system-packages 2>/dev/null || \
    python3 -m pip install aider-chat --user
    print_step "Python and Aider installed"
fi

# Create an alias for easy offline aider usage
AIDER_ALIAS="alias aider-offline='aider --model ollama_chat/$CHAT_MODEL'"

# Add to shell config
SHELL_RC="$HOME/.zshrc"
if [ -f "$SHELL_RC" ]; then
    if ! grep -q "aider-offline" "$SHELL_RC"; then
        echo "" >> "$SHELL_RC"
        echo "# Off-the-Grid Coding: Aider with local model" >> "$SHELL_RC"
        echo "$AIDER_ALIAS" >> "$SHELL_RC"
    fi
else
    echo "$AIDER_ALIAS" >> "$SHELL_RC"
fi

print_step "Added 'aider-offline' shortcut to your terminal"
print_info "Usage: cd into any project folder and type 'aider-offline'"

# ============================================================================
# STEP 8: Install Open WebUI (ChatGPT-like Interface)
# ============================================================================
print_header "STEP 8: OPEN WEBUI (Optional: ChatGPT-like Chat Interface)"

print_info "Open WebUI gives you a ChatGPT/Claude-like chat interface"
print_info "that connects to your local models."
echo ""
read -p "Install Open WebUI? (y/n): " INSTALL_WEBUI

if [[ "$INSTALL_WEBUI" == "y" || "$INSTALL_WEBUI" == "Y" ]]; then
    if command -v pip3 &> /dev/null || command -v python3 &> /dev/null; then
        print_info "Installing Open WebUI..."
        python3 -m pip install open-webui --break-system-packages 2>/dev/null || \
        python3 -m pip install open-webui --user 2>/dev/null || true
        print_step "Open WebUI installed"
        print_info "Start it anytime with: open-webui serve"
        print_info "Then open http://localhost:8080 in your browser"

        # Add alias
        if ! grep -q "webui-start" "$SHELL_RC"; then
            echo "alias webui-start='open-webui serve'" >> "$SHELL_RC"
        fi
    fi
else
    print_info "Skipped. You can install later with: pip3 install open-webui"
fi

# ============================================================================
# STEP 9: Quick Test
# ============================================================================
print_header "STEP 9: TESTING YOUR SETUP"

print_info "Running a quick test with your coding model..."
echo ""

if RESPONSE=$(ollama run "$CHAT_MODEL" "Write a TypeScript function that takes an array of numbers and returns the sum. Keep it short." 2>&1); then
    print_step "Model is working! Here's what it generated:"
    echo ""
    echo -e "${CYAN}$RESPONSE${NC}"
    echo ""
else
    print_error "Model test failed. Try running manually: ollama run $CHAT_MODEL"
    print_error "Error: $RESPONSE"
fi

# ============================================================================
# DONE
# ============================================================================
print_header "SETUP COMPLETE!"

echo -e "${GREEN}${BOLD}Your offline coding environment is ready!${NC}"
echo ""
echo -e "${BOLD}What you now have:${NC}"
echo ""
echo -e "  ${CYAN}1. Ollama${NC}          — Local LLM engine (runs automatically)"
echo -e "     Models installed:"
echo -e "       • $CHAT_MODEL (main coding brain)"
echo -e "       • $COMPLETION_MODEL (fast autocomplete)"
echo -e "       • $REASONING_MODEL (complex reasoning)"
echo ""
echo -e "  ${CYAN}2. VS Code + Continue${NC} — AI-powered code editor"
echo -e "     Open VS Code → Cmd+L to chat with AI"
echo -e "     Tab for AI autocomplete suggestions"
echo ""
echo -e "  ${CYAN}3. Aider${NC}            — Terminal coding agent (like Claude Code)"
echo -e "     Usage: cd your-project && aider-offline"
echo ""
if [[ "$INSTALL_WEBUI" == "y" || "$INSTALL_WEBUI" == "Y" ]]; then
echo -e "  ${CYAN}4. Open WebUI${NC}       — ChatGPT-like interface"
echo -e "     Start: webui-start"
echo -e "     Open: http://localhost:8080"
echo ""
fi
echo -e "${BOLD}How to use offline:${NC}"
echo -e "  1. Make sure Ollama is running (it auto-starts, but if not: ${CYAN}ollama serve${NC})"
echo -e "  2. Open VS Code — AI autocomplete and chat work immediately"
echo -e "  3. For terminal coding: ${CYAN}aider-offline${NC} in any project folder"
echo ""
echo -e "${BOLD}No internet needed. Everything runs on your Mac.${NC}"
echo ""
echo -e "${YELLOW}Pro tip:${NC} Open a new terminal tab for the aliases to take effect,"
echo -e "or run: ${CYAN}source ~/.zshrc${NC}"
echo ""
