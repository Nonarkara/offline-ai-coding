# Off-the-grid coding

Mac-oriented narrative of the same method as [README.md](README.md). First session and verify table: [QUICKSTART.md](QUICKSTART.md). Privacy: [SECURITY.md](SECURITY.md). Pictures of the stack: [README.md#diagrams](README.md#diagrams).

## The big picture

You are setting up coding assistance — autocomplete, chat, generation, debugging — that **does not need the internet after the first download**. Everything runs on a machine you own. Apple Silicon is where these notes are strongest (unified memory). The installer also tries Linux.

This is **not** Claude, Copilot, or Cursor. It is Ollama + Continue + Aider on localhost.

**What you'll have when done:**

| Tool | What it does | Stays on |
|------|-------------|----------|
| **Ollama** | Local model runtime | `http://127.0.0.1:11434` |
| **VS Code + Continue.dev** | Editor chat + tab complete | `~/.continue/config.json` → localhost, telemetry off |
| **Aider** | Terminal agent (`aider-offline`) | Same local chat model |
| **Open WebUI** (optional) | Browser chat | `http://localhost:8080` |

**Models the installer picks** (from `install.sh`, not a ranking):

| Your RAM | Chat | Autocomplete | Reasoning |
|----------|------|--------------|-----------|
| 64 GB+ | `qwen2.5-coder:32b` | `qwen2.5-coder:7b` | `deepseek-r1:14b` |
| 32 GB | `qwen2.5-coder:32b` | `qwen2.5-coder:7b` | `deepseek-r1:7b` |
| 16 GB | `qwen2.5-coder:14b` | `qwen2.5-coder:7b` | `deepseek-r1:7b` |
| 8 GB | `gemma4:e4b` | `qwen2.5-coder:3b` | `deepseek-r1:1.5b` |

---

## How to install (one command)

Open **Terminal** (Cmd+Space → Terminal), then:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Nonarkara/offline-ai-coding/main/install.sh)
```

Or clone this repo and run `./install.sh`. Do **not** start from `setup-offline-coding.sh` — that helper is older. **`install.sh` is current.**

The script will:
1. Detect RAM and choose models
2. Install Homebrew if needed
3. Install Ollama
4. Download models (one-time, needs internet)
5. Install/configure VS Code + Continue.dev
6. Install Aider (`aider-offline`)
7. Optionally install Open WebUI / Pocket TTS
8. Print a short verify — then you run `bash scripts/verify.sh`

**Total time:** ~20-40 minutes (mostly downloads).
**Internet needed:** Only for this initial setup. After that, localhost. See [SECURITY.md](SECURITY.md) for what “offline” does and does not mean.

---

## Daily Usage (No Internet Needed)

### Using VS Code (Your Main Workflow)

1. **Open VS Code** as you normally would
2. **AI Autocomplete** — just type code. Suggestions appear automatically (press Tab to accept)
3. **AI Chat** — press `Cmd+L` to open the AI chat sidebar
   - Ask it to write code: "Create a React component for a dashboard card"
   - Ask it to explain code: highlight code, Cmd+L, "explain this"
   - Ask it to fix bugs: highlight code, Cmd+L, "fix this error"
   - Ask it to refactor: highlight code, Cmd+L, "refactor this to use TypeScript interfaces"
4. **Inline Edit** — press `Cmd+I` to edit code inline with AI

### Using Aider (Terminal — Like Claude Code)

This is for when you want an AI agent that can read your whole project and make changes across multiple files:

```bash
cd ~/your-project-folder
aider-offline
```

Then just chat with it:
- "Add dark mode support to the dashboard"
- "Fix the TypeScript errors in the API routes"
- "Create a new component for displaying satellite data"
- "Refactor the state management to use Zustand"

Aider reads your project, makes changes, and commits them to git automatically.

### Using Open WebUI (If Installed)

For when you just want to chat with AI (brainstorm, ask questions, plan architecture):

```bash
webui-start
```

Then open http://localhost:8080 in your browser.

---

## Troubleshooting

### "Ollama not running"
```bash
ollama serve
```
(Or just open the Ollama app from Applications)

### "Model not found"
```bash
ollama list          # See what's installed
ollama pull qwen2.5-coder:32b   # Re-download if needed
```

### "Continue.dev not connecting"
Make sure Ollama is running (check for the llama icon in your menu bar), then restart VS Code.

### "Aider can't find the model"
```bash
aider --model ollama_chat/qwen2.5-coder:32b
```
(Replace with your actual model name from `ollama list`)

### Want to try a different model?
```bash
ollama pull codestral:22b       # Mistral's coding model
ollama pull deepseek-coder-v2   # DeepSeek alternative
```

---

## Upgrading Later

To update models and tools when you're back online:

```bash
# Update Ollama
brew upgrade ollama

# Update models (pulls latest versions)
ollama pull qwen2.5-coder:32b
ollama pull qwen2.5-coder:7b

# Update Aider
pip3 install --upgrade aider-chat

# Check for new models
ollama search coder    # See what's available
```

---

## How it all fits together

Illustrated versions (install flow, stack, network-once vs localhost): [README.md#diagrams](README.md#diagrams).

```
Your machine
  Ollama  ←──  VS Code + Continue.dev
     ↑    ←──  Aider (aider-offline)
     ↑    ←──  Open WebUI (optional)
     └──  Chat / complete / reason weights on disk
          http://127.0.0.1:11434
```

After the first download, those arrows do not leave the box. Pointing the same editor at a hosted API is not this method.

---

*Installer and model IDs follow `install.sh`. Update tools when you are back online; do not treat a cloud wire-up as “offline.”*
