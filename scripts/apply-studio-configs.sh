#!/usr/bin/env bash
# Copy example configs into the user's home directory without overwriting
# existing files and without writing API keys.
#
# Usage (from repo root): bash scripts/apply-studio-configs.sh
#          --force   replace existing target files (still never writes keys)

set -euo pipefail

FORCE=0
if [[ "${1:-}" == "--force" ]]; then
    FORCE=1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EX="$ROOT/examples"

copy_if() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [[ -e "$dest" && "$FORCE" -ne 1 ]]; then
        echo "  skip (exists): $dest"
        return 0
    fi
    cp "$src" "$dest"
    echo "  wrote: $dest"
}

echo "Applying studio example configs (no API keys)…"
copy_if "$EX/opencode.jsonc" "$HOME/.config/opencode/opencode.jsonc"
copy_if "$EX/continue.config.yaml" "$HOME/.continue/config.yaml"
copy_if "$EX/aider.conf.yml" "$HOME/.aider.conf.yml"

if [[ ! -e "$HOME/.continue/.env" ]]; then
    copy_if "$EX/continue.env.example" "$HOME/.continue/.env"
    echo "  fill OPENROUTER_API_KEY in ~/.continue/.env if you use VS Code + OpenRouter"
else
    echo "  skip (exists): $HOME/.continue/.env"
fi

echo ""
echo "Next:"
echo "  • Local: ollama serve (or Ollama.app), then VS Code Cmd+L / aider-offline / opencode"
echo "  • OpenRouter: add a key to ~/.continue/.env AND export OPENROUTER_API_KEY for CLI"
echo "  • OpenCode: opencode  then  /connect  (OpenRouter) — key goes to auth.json, not git"
echo "  • Docs: docs/OPENCODE.md  docs/OPENROUTER.md  docs/GUARDRAILS.md"
