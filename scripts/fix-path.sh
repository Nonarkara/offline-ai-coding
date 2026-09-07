#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# ============================================================================
# PATH REPAIR UTILITY
# Fixes broken shell PATH on macOS and Linux
#
# The #1 cause of "command not found" errors.
# Run this if basic commands (ls, mkdir, cat) don't work.
#
# Usage: bash scripts/fix-path.sh
# ============================================================================

echo "Checking your PATH..."

STANDARD_PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Detect Homebrew path
if [[ "$(uname)" == "Darwin" ]]; then
    if [[ "$(uname -m)" == "arm64" ]]; then
        BREW_PATH="/opt/homebrew/bin:/opt/homebrew/sbin"
    else
        BREW_PATH="/usr/local/bin"
    fi
    SHELL_RC="$HOME/.zprofile"
else
    BREW_PATH="/home/linuxbrew/.linuxbrew/bin"
    SHELL_RC="$HOME/.bashrc"
fi

FULL_PATH="${BREW_PATH}:${STANDARD_PATH}"

# Fix for this session
export PATH="${FULL_PATH}:${PATH}"

# Test
if command -v ls &>/dev/null; then
    echo "✓ PATH is working (ls found)"
else
    echo "✗ PATH is still broken. Contact support."
    exit 1
fi

# Make permanent
if ! grep -q "# Offline AI Coding PATH fix" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# Offline AI Coding PATH fix" >> "$SHELL_RC"
    echo "export PATH=\"${FULL_PATH}:\$PATH\"" >> "$SHELL_RC"
    echo "✓ PATH fix saved to $SHELL_RC"
    echo "  Close and reopen Terminal for it to take effect."
else
    echo "✓ PATH fix already in $SHELL_RC"
fi
