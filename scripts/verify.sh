#!/usr/bin/env bash
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
check "Qwen Coder model" "ollama list | grep -q qwen2.5-coder"
check "DeepSeek model" "ollama list | grep -q deepseek"

echo ""
echo "Configuration:"
check "Continue.dev config" "test -f ~/.continue/config.json"
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
    echo "  🎉 Everything is working! You're ready to code offline."
    echo ""
    echo "  Next steps:"
    echo "  • Open VS Code → Cmd+L → chat with AI"
    echo "  • Or: cd ~/your-project && aider-offline"
else
    echo ""
    echo "  Some checks failed. See TROUBLESHOOTING.md for fixes."
    echo "  Or re-run the installer: ./install.sh"
fi
