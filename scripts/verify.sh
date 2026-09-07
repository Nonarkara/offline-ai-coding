#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Non Arkaraprasertkul / Axiom X Co., Ltd.
# ============================================================================
# INSTALLATION VERIFIER
# Checks that everything is installed and working
#
# Usage: bash scripts/verify.sh
# ============================================================================

echo ""
echo "Verifying your offline AI coding setup..."
echo ""

PASS=0
FAIL=0

check() {
    local name=$1
    local cmd=$2

    if eval "$cmd" &>/dev/null; then
        echo "  ✓ $name"
        PASS=$((PASS + 1))
    else
        echo "  ✗ $name"
        FAIL=$((FAIL + 1))
    fi
}

echo "Core tools:"
check "Homebrew installed" "command -v brew"
check "Ollama installed" "command -v ollama"
check "Ollama running" "pgrep -x ollama"
check "VS Code installed" "command -v code || test -d '/Applications/Visual Studio Code.app'"
check "Python3 installed" "command -v python3"

echo ""
echo "AI Models:"
check "Chat model (Qwen Coder or Gemma 4)" "ollama list | grep -qE 'qwen2.5-coder|gemma4'"
check "Reasoning model (DeepSeek)" "ollama list | grep -q deepseek"

echo ""
echo "Configuration:"
check "Continue.dev config" "test -f ~/.continue/config.json"
check "Continue points at localhost" "grep -q 'localhost:11434' ~/.continue/config.json"
check "Continue telemetry off" "grep -q 'allowAnonymousTelemetry.: false' ~/.continue/config.json"
check "Aider installed" "command -v aider"
check "aider-offline alias" "grep -q aider-offline ~/.zshrc 2>/dev/null || grep -q aider-offline ~/.zprofile 2>/dev/null || grep -q aider-offline ~/.bashrc 2>/dev/null"

echo ""
echo "Environment:"
check "PATH includes /usr/bin" "echo \$PATH | grep -q /usr/bin"
check "PATH includes homebrew" "echo \$PATH | grep -q homebrew"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Results: $PASS passed, $FAIL failed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $FAIL -eq 0 ]; then
    echo ""
    echo "  Everything required is in place. Next:"
    echo "  • VS Code → Cmd+L / Ctrl+L → 'Reply with: I am working locally.'"
    echo "  • Tab-complete in a file"
    echo "  • Or: cd ~/your-project && aider-offline"
    echo "  • Privacy: grep apiBase ~/.continue/config.json  (must be localhost)"
    echo ""
    echo "  See QUICKSTART.md → What success looks like."
else
    echo ""
    echo "  Some checks failed. See TROUBLESHOOTING.md — do not add a cloud API key."
    echo "  Or re-run the installer: ./install.sh"
fi
