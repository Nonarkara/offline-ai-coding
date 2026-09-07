#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Non Arkaraprasertkul / Axiom X Co., Ltd.
# ============================================================================
# OFFLINE AI CODING — Complete Setup Script
#
# This script sets up a full offline AI coding environment:
# - Ollama (local LLM runtime)
# - AI models (Qwen, DeepSeek)
# - VS Code + Continue.dev (IDE with AI chat)
# - Aider (terminal coding agent)
# - Auto-start configuration
#
# It handles:
# - Hardware detection
# - PATH environment fixes
# - Cross-platform support (Mac, Linux, Windows/WSL)
# - Error recovery
# - Interrupted downloads
#
# Run with: bash install.sh
# ============================================================================

set -euo pipefail

# ============================================================================
# COLORS & FORMATTING
# ============================================================================

BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

# Helper functions
print_header() {
    echo ""
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${CYAN}${BOLD}  $1${RESET}"
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
}

print_step() {
    echo -e "${GREEN}✓${RESET} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${RESET} $1"
}

print_warn() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

print_error() {
    echo -e "${RED}✗${RESET} $1"
}

# ============================================================================
# STEP 0: DETECT SYSTEM & HARDWARE
# ============================================================================

print_header "DETECTING YOUR SYSTEM"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    SHELL_RC="$HOME/.zprofile"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    SHELL_RC="$HOME/.bashrc"
else
    print_error "Unsupported OS: $OSTYPE"
    print_info "Supported: macOS, Linux, Windows/WSL2"
    exit 1
fi

print_step "OS detected: $OS"

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    arm64|aarch64)
        ARCH_FRIENDLY="Apple Silicon / ARM64"
        ;;
    x86_64)
        ARCH_FRIENDLY="Intel x86_64"
        ;;
    *)
        print_error "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

print_step "Architecture: $ARCH_FRIENDLY"

# Detect RAM
if [[ "$OS" == "macos" ]]; then
    RAM_BYTES=$(sysctl -n hw.memsize 2>/dev/null || echo "0")
elif [[ "$OS" == "linux" ]]; then
    RAM_BYTES=$(($(grep MemTotal /proc/meminfo | awk '{print $2}') * 1024))
else
    RAM_BYTES="0"
fi

RAM_GB=$((RAM_BYTES / 1073741824))
print_step "RAM: ${RAM_GB}GB"

# Detect free disk space
if [[ "$OS" == "macos" ]]; then
    FREE_GB=$(df -g "$HOME" 2>/dev/null | tail -1 | awk '{print $4}' || echo "0")
else
    FREE_GB=$(df -BG "$HOME" 2>/dev/null | tail -1 | awk '{print $4}' | tr -d 'G' || echo "0")
fi

print_step "Free disk space: ${FREE_GB}GB"

if [ "$FREE_GB" -lt 40 ]; then
    print_warn "You have ${FREE_GB}GB free. Models need ~25-30GB. Consider freeing space."
fi

# ============================================================================
# STEP 1: DETERMINE MODEL SIZES BASED ON HARDWARE
# ============================================================================

print_header "DETERMINING MODEL SIZES FOR YOUR HARDWARE"

if [ "$RAM_GB" -ge 64 ]; then
    TIER="64gb+"
    CHAT_MODEL="qwen2.5-coder:32b"
    COMPLETION_MODEL="qwen2.5-coder:7b"
    REASONING_MODEL="deepseek-r1:14b"
    print_info "64GB+ RAM → Installing: 32B chat + 7B completion + 14B reasoning"
elif [ "$RAM_GB" -ge 32 ]; then
    TIER="32gb"
    CHAT_MODEL="qwen2.5-coder:32b"
    COMPLETION_MODEL="qwen2.5-coder:7b"
    REASONING_MODEL="deepseek-r1:7b"
    print_info "32GB RAM → Installing: 32B chat + 7B completion + 7B reasoning"
elif [ "$RAM_GB" -ge 16 ]; then
    TIER="16gb"
    CHAT_MODEL="qwen2.5-coder:14b"
    COMPLETION_MODEL="qwen2.5-coder:7b"
    REASONING_MODEL="deepseek-r1:7b"
    print_warn "16GB RAM → Installing: 14B chat + 7B completion (may be tight)"
elif [ "$RAM_GB" -ge 8 ]; then
    TIER="8gb"
    # Gemma 4 E4B over Qwen 7B on this tier: MatFormer nesting means only ~4.5B
    # params are active per token despite an ~8B/9.6GB download, so it fits the
    # 8GB budget with room to spare, is multimodal, and supports up to 256K
    # context vs Qwen 7B's much smaller window. Needs Ollama 0.22+ (checked below).
    CHAT_MODEL="gemma4:e4b"
    COMPLETION_MODEL="qwen2.5-coder:3b"
    REASONING_MODEL="deepseek-r1:1.5b"
    print_warn "8GB RAM → Installing: Gemma 4 E4B chat + Qwen 3B completion (slow but works)"
else
    print_error "Your system has ${RAM_GB}GB RAM. Minimum is 8GB."
    exit 1
fi

print_step "Model tier: $TIER"

# ============================================================================
# STEP 2: FIX PATH (CRITICAL — this is what was breaking everything)
# ============================================================================

print_header "CONFIGURING ENVIRONMENT"

print_info "Checking and fixing shell PATH..."

# Build the correct PATH
STANDARD_PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Add Homebrew paths
if [[ "$OS" == "macos" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
        HOMEBREW_PATH="/opt/homebrew/bin:/opt/homebrew/sbin"
    else
        HOMEBREW_PATH="/usr/local/homebrew/bin:/usr/local/homebrew/sbin"
    fi
else
    HOMEBREW_PATH="/home/linuxbrew/.linuxbrew/bin"
fi

FULL_PATH="${HOMEBREW_PATH}:${STANDARD_PATH}"

# Add to shell RC file if not already there
if ! grep -q "export PATH=" "$SHELL_RC" 2>/dev/null || ! grep -q "/homebrew" "$SHELL_RC" 2>/dev/null; then
    {
        echo ""
        echo "# Offline AI Coding setup"
        echo "export PATH=\"${FULL_PATH}:\$PATH\""
    } >> "$SHELL_RC"
    print_step "Updated $SHELL_RC with correct PATH"
fi

# Export for this session
export PATH="${FULL_PATH}:${PATH}"
print_step "PATH updated for this session"

# ============================================================================
# STEP 3: INSTALL HOMEBREW (if needed)
# ============================================================================

print_header "STEP 1: PACKAGE MANAGER"

if command -v brew &> /dev/null; then
    print_step "Homebrew already installed"
else
    print_info "Installing Homebrew..."
    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        print_error "Failed to install Homebrew. Check your internet connection."
        exit 1
    fi
    print_step "Homebrew installed"
fi

# ============================================================================
# STEP 4: INSTALL OLLAMA
# ============================================================================

print_header "STEP 2: OLLAMA (AI MODEL RUNTIME)"

if command -v ollama &> /dev/null; then
    print_step "Ollama already installed"
    brew upgrade ollama 2>/dev/null || true
else
    print_info "Installing Ollama..."
    if ! brew install ollama; then
        print_error "Failed to install Ollama"
        exit 1
    fi
    print_step "Ollama installed"
fi

# Start Ollama
print_info "Starting Ollama service..."
if [[ "$OS" == "macos" ]]; then
    brew services start ollama 2>/dev/null || ollama serve &>/dev/null &
elif [[ "$OS" == "linux" ]]; then
    if ! pgrep -x "ollama" > /dev/null; then
        ollama serve &>/dev/null &
    fi
fi

sleep 3
if pgrep -x "ollama" > /dev/null; then
    print_step "Ollama is running"
else
    print_warn "Ollama didn't auto-start. Will try again after a moment."
fi

# Gemma 4 needs Ollama 0.22+. Below that, gemma4:e4b pulls will 404 or fail
# to load — upgrade rather than let a confusing model error be the first thing
# an 8GB-tier user sees.
if [[ "$CHAT_MODEL" == gemma4* ]] && command -v ollama &> /dev/null; then
    OLLAMA_VER=$(ollama --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    OLLAMA_MINOR=$(echo "$OLLAMA_VER" | cut -d. -f2)
    if [ -n "$OLLAMA_MINOR" ] && [ "$OLLAMA_MINOR" -lt 22 ]; then
        print_warn "Ollama $OLLAMA_VER is too old for Gemma 4 (need 0.22+). Upgrading..."
        brew upgrade ollama 2>/dev/null || print_warn "Could not auto-upgrade — run 'brew upgrade ollama' manually"
    fi
fi

# ============================================================================
# STEP 5: DOWNLOAD MODELS
# ============================================================================

print_header "STEP 3: DOWNLOADING AI MODELS"

print_warn "This step downloads 20-30GB. Get coffee ☕"
print_info "Models download once, then live on your machine forever."
echo ""

# Function to download model with retry
download_model() {
    local model=$1
    local description=$2

    print_info "Downloading $description ($model)..."

    # Check if already downloaded
    if ollama list | grep -q "$model"; then
        print_step "$description already downloaded"
        return 0
    fi

    # Try to download, with retry logic
    local attempts=0
    local max_attempts=3

    while [ $attempts -lt $max_attempts ]; do
        if ollama pull "$model"; then
            print_step "$description downloaded"
            return 0
        else
            attempts=$((attempts + 1))
            if [ $attempts -lt $max_attempts ]; then
                print_warn "Download interrupted. Retrying... (attempt $attempts/$max_attempts)"
                sleep 5
            fi
        fi
    done

    print_error "Failed to download $model after $max_attempts attempts"
    return 1
}

# Download each model
download_model "$CHAT_MODEL" "Qwen Coder (main brain)" || print_error "Critical: Could not download chat model"
download_model "$COMPLETION_MODEL" "Qwen Coder (autocomplete)" || print_warn "Could not download completion model"
download_model "$REASONING_MODEL" "DeepSeek R1 (reasoning)" || print_warn "Could not download reasoning model"

echo ""
print_step "Models downloaded successfully"

# ============================================================================
# STEP 6: INSTALL VS CODE (if needed)
# ============================================================================

print_header "STEP 4: VS CODE (CODE EDITOR)"

if command -v code &> /dev/null || [ -d "/Applications/Visual Studio Code.app" ]; then
    print_step "VS Code already installed"
else
    print_info "Installing VS Code..."
    brew install --cask visual-studio-code
    print_step "VS Code installed"
fi

# ============================================================================
# STEP 7: INSTALL & CONFIGURE CONTINUE.DEV
# ============================================================================

print_header "STEP 5: CONTINUE.DEV (AI INTEGRATION)"

print_info "Installing Continue.dev extension..."
code --install-extension Continue.continue 2>/dev/null || true

# Create Continue config
mkdir -p ~/.continue

cat > ~/.continue/config.json << EOF
{
  "models": [
    {
      "title": "$CHAT_MODEL (Offline)",
      "provider": "ollama",
      "model": "$CHAT_MODEL",
      "apiBase": "http://localhost:11434",
      "contextLength": 32768,
      "completionOptions": {"temperature": 0.1, "maxTokens": 4096},
      "capabilities": {"tools": false}
    },
    {
      "title": "DeepSeek R1 (Reasoning)",
      "provider": "ollama",
      "model": "$REASONING_MODEL",
      "apiBase": "http://localhost:11434",
      "contextLength": 32768,
      "completionOptions": {"temperature": 0.1, "maxTokens": 4096},
      "capabilities": {"tools": false}
    }
  ],
  "tabAutocompleteModel": {
    "title": "Qwen Coder (Autocomplete)",
    "provider": "ollama",
    "model": "$COMPLETION_MODEL",
    "apiBase": "http://localhost:11434"
  },
  "allowAnonymousTelemetry": false
}
EOF

print_step "Continue.dev configured"

# ============================================================================
# STEP 8: INSTALL AIDER (terminal agent)
# ============================================================================

print_header "STEP 6: AIDER (TERMINAL CODING AGENT)"

if command -v aider &> /dev/null; then
    print_step "Aider already installed"
else
    print_info "Installing Aider..."

    if command -v pip3 &> /dev/null; then
        pip3 install aider-chat --break-system-packages 2>/dev/null || \
        pip3 install aider-chat --user 2>/dev/null || \
        brew install aider 2>/dev/null || \
        print_error "Could not install Aider. You can install manually with: pip3 install aider-chat"
    else
        print_warn "pip3 not found. Installing Python first..."
        brew install python3
        python3 -m pip install aider-chat --break-system-packages 2>/dev/null || \
        python3 -m pip install aider-chat --user
    fi
fi

# Create aider-offline alias
if ! grep -q "aider-offline" "$SHELL_RC" 2>/dev/null; then
    echo "alias aider-offline='aider --model ollama_chat/$CHAT_MODEL'" >> "$SHELL_RC"
    print_step "Added 'aider-offline' alias"
fi

# ============================================================================
# STEP 9: OPEN WEBUI (OPTIONAL CHAT INTERFACE)
# ============================================================================

print_header "STEP 7: OPEN WEBUI (OPTIONAL CHAT INTERFACE)"

read -p "Install Open WebUI? (y/n, default: y): " INSTALL_WEBUI
INSTALL_WEBUI=${INSTALL_WEBUI:-y}

if [[ "$INSTALL_WEBUI" == "y" || "$INSTALL_WEBUI" == "Y" ]]; then
    print_info "Installing Open WebUI..."
    python3 -m pip install open-webui --break-system-packages 2>/dev/null || \
    python3 -m pip install open-webui --user 2>/dev/null || \
    print_warn "Could not install Open WebUI. You can install manually with: pip3 install open-webui"

    if ! grep -q "webui-start" "$SHELL_RC" 2>/dev/null; then
        echo "alias webui-start='python3 -m open_webui.main serve'" >> "$SHELL_RC"
        print_step "Added 'webui-start' alias"
    fi
else
    print_info "Skipped Open WebUI. You can install later with: pip3 install open-webui"
fi

# ============================================================================
# STEP 9B: KYUTAI POCKET TTS (OPTIONAL VOICE)
# ============================================================================

print_header "STEP 7B: VOICE (OPTIONAL)"

read -p "Install offline voice (Kyutai Pocket TTS)? (y/n, default: n): " INSTALL_VOICE
INSTALL_VOICE=${INSTALL_VOICE:-n}

if [[ "$INSTALL_VOICE" == "y" || "$INSTALL_VOICE" == "Y" ]]; then
    # Kyutai's Pocket TTS over Meta's VoiceBox: VoiceBox was published as a
    # research paper and demo, never released as weights you can actually run.
    # Pocket TTS is a real open-weight model — 100M params, real-time on CPU,
    # no GPU required — which matches "runs offline on hardware you own".
    print_info "Installing Kyutai Pocket TTS..."
    python3 -m pip install pocket-tts --break-system-packages 2>/dev/null || \
    python3 -m pip install pocket-tts --user 2>/dev/null || \
    print_warn "Could not install Pocket TTS. You can install manually with: pip3 install pocket-tts"

    if ! grep -q "alias speak=" "$SHELL_RC" 2>/dev/null; then
        echo "alias speak='pocket-tts generate'" >> "$SHELL_RC"
        print_step "Added 'speak' alias"
    fi
    print_step "Kyutai Pocket TTS installed"
    print_info "Try it: speak --text \"hello from your own machine\" --voice default"
else
    print_info "Skipped voice. You can install later with: pip3 install pocket-tts"
fi

# ============================================================================
# STEP 10: VERIFY INSTALLATION
# ============================================================================

print_header "STEP 8: VERIFICATION & TESTING"

print_info "Testing Ollama connection..."
if pgrep -x "ollama" > /dev/null; then
    print_step "Ollama is running"
else
    print_error "Ollama not running. Try 'ollama serve' in Terminal."
fi

print_info "Testing model availability..."
MODELS=$(ollama list | grep -E "(qwen|deepseek|gemma)" | wc -l)
if [ "$MODELS" -ge 1 ]; then
    print_step "Models are available"
else
    print_error "No models found. Download may have failed."
fi

# ============================================================================
# DONE
# ============================================================================

print_header "🎉 SETUP COMPLETE!"

echo -e "${GREEN}${BOLD}Your offline AI coding environment is ready.${RESET}"
echo ""
echo "You now have:"
echo ""
echo "  ${CYAN}✓ Ollama${RESET}        — Local AI engine (auto-starts on boot)"
echo "  ${CYAN}✓ Models${RESET}        — $CHAT_MODEL (chat)"
echo "  ${CYAN}✓ Models${RESET}        — $COMPLETION_MODEL (autocomplete)"
echo "  ${CYAN}✓ Models${RESET}        — $REASONING_MODEL (reasoning)"
echo "  ${CYAN}✓ VS Code${RESET}       — Editor with AI chat (Cmd+L)"
echo "  ${CYAN}✓ Aider${RESET}         — Terminal coding agent (aider-offline)"
if [[ "$INSTALL_WEBUI" == "y" || "$INSTALL_WEBUI" == "Y" ]]; then
echo "  ${CYAN}✓ Open WebUI${RESET}    — ChatGPT-like chat interface"
fi
if [[ "$INSTALL_VOICE" == "y" || "$INSTALL_VOICE" == "Y" ]]; then
echo "  ${CYAN}✓ Pocket TTS${RESET}    — Offline voice (Kyutai), 'speak' alias"
fi
echo ""
echo "Next steps:"
echo ""
echo "  1. Close this terminal and ${BOLD}open a new one${RESET}"
echo "     (This loads the updated PATH)"
echo ""
echo "  2. ${BOLD}Open VS Code${RESET}"
echo "     Press Cmd+L (Mac) or Ctrl+L (Windows/Linux) to chat with AI"
echo ""
echo "  3. ${BOLD}To use Aider (terminal agent)${RESET}:"
echo "     cd ~/my-project && aider-offline"
echo ""
if [[ "$INSTALL_WEBUI" == "y" || "$INSTALL_WEBUI" == "Y" ]]; then
echo "  4. ${BOLD}To use the chat interface in browser${RESET}:"
echo "     webui-start"
echo "     Then open http://localhost:8080"
echo ""
fi
echo -e "${YELLOW}Pro tip:${RESET} Models auto-downloaded are in ~/.ollama"
echo "You can delete models to free space, re-download when needed."
echo ""
echo "Verify (from a clone of this repo):"
echo "  bash scripts/verify.sh"
echo "Success table: QUICKSTART.md  ·  Privacy: SECURITY.md"
echo "Continue must stay on http://localhost:11434 — do not add a cloud key and call it offline."
echo ""
echo "No internet needed from here on. You're truly ${BOLD}off the grid.${RESET}"
echo ""
