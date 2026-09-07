#!/bin/bash
# ============================================================================
# SPDX-License-Identifier: MIT
# INSTALL AUTO-START
# Run this ONCE to make Ollama auto-start when your Mac boots
# and create a desktop app launcher for your coding environment
# ============================================================================

echo "Setting up auto-start and launcher..."

# 1. Make Ollama auto-start on login via Homebrew services
brew services start ollama 2>/dev/null

# 2. Copy the launcher script to a convenient location
cp "$(dirname "$0")/start-coding.sh" ~/Projects/off-the-grid-coding/start-coding.sh 2>/dev/null
chmod +x ~/Projects/off-the-grid-coding/start-coding.sh

# 3. Create a macOS .app so you can double-click from Finder or Spotlight
APP_DIR="$HOME/Applications/Off-the-Grid Coding.app/Contents/MacOS"
mkdir -p "$APP_DIR"
mkdir -p "$HOME/Applications/Off-the-Grid Coding.app/Contents"

# Write the app launcher
cat > "$APP_DIR/launch" << 'LAUNCH'
#!/bin/bash

# Start Ollama if not running
if ! pgrep -x "ollama" > /dev/null; then
    ollama serve &>/dev/null &
    sleep 3
fi

# Start Open WebUI if not running
if ! lsof -i :8080 > /dev/null 2>&1; then
    python3 -m open_webui.main serve &>/dev/null &
    sleep 2
fi

# Open VS Code
if [ -d "/Applications/Cursor.app" ]; then
    open -a "Cursor" ~/Projects/
elif [ -d "/Applications/Visual Studio Code.app" ]; then
    open -a "Visual Studio Code" ~/Projects/
fi

# Open chat UI
sleep 2
open http://localhost:8080
LAUNCH

chmod +x "$APP_DIR/launch"

# Write Info.plist
cat > "$HOME/Applications/Off-the-Grid Coding.app/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>launch</string>
    <key>CFBundleName</key>
    <string>Off-the-Grid Coding</string>
    <key>CFBundleIdentifier</key>
    <string>com.nonarkara.offthegrid</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
</dict>
</plist>
PLIST

echo ""
echo "✅ Done! Here's what's set up:"
echo ""
echo "   🔄 Ollama auto-starts when your Mac boots"
echo "   🚀 'Off-the-Grid Coding' app created in ~/Applications/"
echo ""
echo "   You can now:"
echo "   • Search 'Off-the-Grid' in Spotlight (Cmd+Space) to launch everything"
echo "   • Or find it in Finder → your home folder → Applications"
echo ""
echo "   What launches when you open it:"
echo "   1. AI engine (Ollama) starts if not running"
echo "   2. Chat interface (Open WebUI) starts"
echo "   3. VS Code opens your Projects folder"
echo "   4. Browser opens the chat UI"
echo ""
