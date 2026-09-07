#!/bin/bash
# Simple Aider launcher
# SPDX-License-Identifier: MIT
# Use this to start your offline AI coding agent

# Make sure we're in a project directory
if [ ! -d ".git" ]; then
    echo "No git repo found in current directory."
    echo "To use Aider, you need to be in a project folder with git initialized."
    echo ""
    echo "Examples:"
    echo "  mkdir ~/Projects/my-project && cd ~/Projects/my-project && git init"
    echo "  cd ~/Projects/existing-project"
    echo ""
    exit 1
fi

# Launch Aider with the offline Qwen model
echo "🚀 Starting offline AI coding agent..."
echo ""
aider --model ollama_chat/qwen2.5-coder:32b
