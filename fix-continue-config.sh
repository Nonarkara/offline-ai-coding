#!/bin/bash
# Fix Continue.dev config to work properly with Ollama models
# SPDX-License-Identifier: MIT

# Detect RAM for model selection
RAM_BYTES=$(sysctl -n hw.memsize)
RAM_GB=$((RAM_BYTES / 1073741824))

if [ "$RAM_GB" -ge 32 ]; then
    CHAT_MODEL="qwen2.5-coder:32b"
    COMPLETION_MODEL="qwen2.5-coder:7b"
    REASONING_MODEL="deepseek-r1:14b"
elif [ "$RAM_GB" -ge 16 ]; then
    CHAT_MODEL="qwen2.5-coder:14b"
    COMPLETION_MODEL="qwen2.5-coder:3b"
    REASONING_MODEL="deepseek-r1:7b"
else
    CHAT_MODEL="qwen2.5-coder:7b"
    COMPLETION_MODEL="qwen2.5-coder:1.5b"
    REASONING_MODEL="deepseek-r1:7b"
fi

mkdir -p ~/.continue

cat > ~/.continue/config.json << ENDCONFIG
{
  "models": [
    {
      "title": "Qwen Coder (Offline)",
      "provider": "ollama",
      "model": "$CHAT_MODEL",
      "apiBase": "http://localhost:11434",
      "contextLength": 32768,
      "completionOptions": {
        "temperature": 0.1,
        "maxTokens": 4096
      },
      "capabilities": {
        "tools": false
      }
    },
    {
      "title": "DeepSeek R1 (Reasoning)",
      "provider": "ollama",
      "model": "$REASONING_MODEL",
      "apiBase": "http://localhost:11434",
      "contextLength": 32768,
      "completionOptions": {
        "temperature": 0.1,
        "maxTokens": 4096
      },
      "capabilities": {
        "tools": false
      }
    }
  ],
  "tabAutocompleteModel": {
    "title": "Qwen Coder (Autocomplete)",
    "provider": "ollama",
    "model": "$COMPLETION_MODEL",
    "apiBase": "http://localhost:11434"
  },
  "allowAnonymousTelemetry": false,
  "docs": []
}
ENDCONFIG

echo "✅ Continue.dev config fixed!"
echo "Now restart VS Code (Cmd+Q, then reopen) and try Cmd+L again."
