#!/bin/bash
# ============================================================================
# OFF-THE-GRID: ONE-CLICK LAUNCHER
# Opens your full offline AI coding environment
# Double-click this file or run: bash start-coding.sh
# ============================================================================

# Start Ollama if it's not already running
if ! pgrep -x "ollama" > /dev/null; then
    echo "Starting AI engine..."
    ollama serve &>/dev/null &
    sleep 3
fi

# Start Open WebUI in the background if not running
if ! lsof -i :8080 > /dev/null 2>&1; then
    echo "Starting chat interface..."
    python3 -m open_webui.main serve &>/dev/null &
    sleep 2
fi

# Open VS Code in the Projects folder
echo "Opening VS Code..."
if command -v cursor &> /dev/null; then
    cursor ~/Projects/
elif [ -d "/Applications/Cursor.app" ]; then
    open -a "Cursor" ~/Projects/
elif command -v code &> /dev/null; then
    code ~/Projects/
elif [ -d "/Applications/Visual Studio Code.app" ]; then
    open -a "Visual Studio Code" ~/Projects/
fi

# Open the chat interface in browser
sleep 2
open http://localhost:8080

echo ""
echo "✅ Everything is running!"
echo ""
echo "🖥  VS Code — Cmd+L to chat with AI, Tab for autocomplete"
echo "🌐 Chat UI — http://localhost:8080"
echo "📁 Projects — ~/Projects/"
echo ""
