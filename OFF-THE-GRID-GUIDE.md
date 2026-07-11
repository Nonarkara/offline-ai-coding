# Off-the-Grid Coding: Your Offline AI Coding Environment

## The Big Picture

You're setting up a fully offline coding environment that gives you AI-powered coding assistance — autocomplete, chat, code generation, debugging — without any internet connection. Everything runs locally on your MacBook's Apple Silicon chip.

**What you'll have when done:**

| Tool | What It Does | Equivalent To |
|------|-------------|---------------|
| **Ollama** | Runs AI models locally on your Mac | The "engine" behind everything |
| **VS Code + Continue.dev** | Code editor with AI chat + autocomplete | VS Code + Copilot / Cursor |
| **Aider** | Terminal coding agent | Claude Code / Codex |
| **Open WebUI** (optional) | Chat interface in browser | ChatGPT / Claude.ai |

**AI Models installed:**

| Your RAM | Chat Model | Autocomplete Model | Quality Level |
|----------|-----------|-------------------|--------------|
| 64GB | Qwen 2.5 Coder 32B | Qwen 2.5 Coder 7B | Near GPT-4o |
| 32GB | Qwen 2.5 Coder 32B | Qwen 2.5 Coder 7B | Near GPT-4o |
| 16GB | Qwen 2.5 Coder 14B | Qwen 2.5 Coder 3B | Good |
| 8GB | Qwen 2.5 Coder 7B | Qwen 2.5 Coder 1.5B | Decent |

---

## How to Install (One Command)

Open **Terminal** (press Cmd+Space, type "Terminal", hit Enter), then paste this:

```bash
bash ~/path/to/setup-offline-coding.sh
```

Replace `~/path/to/` with wherever you saved the script. If it's in your Downloads:

```bash
bash ~/Downloads/setup-offline-coding.sh
```

The script will:
1. Detect your Mac's RAM and choose the best models
2. Install Homebrew (Mac package manager) if needed
3. Install Ollama (local AI engine)
4. Download the coding AI models (one-time, needs internet)
5. Install/configure VS Code with Continue.dev extension
6. Install Aider (terminal coding agent)
7. Optionally install Open WebUI (chat interface)
8. Test everything

**Total time:** ~20-40 minutes (mostly model downloads).
**Internet needed:** Only for this initial setup. After that, never again.

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

## How It All Fits Together

```
┌─────────────────────────────────────────────────────┐
│                  YOUR MACBOOK                        │
│                                                     │
│  ┌──────────────┐    ┌───────────────────────────┐  │
│  │   Ollama      │◄───│  VS Code + Continue.dev   │  │
│  │  (AI Engine)  │    │  (Editor + AI Chat +      │  │
│  │               │    │   Autocomplete)           │  │
│  │  Models:      │    └───────────────────────────┘  │
│  │  • Qwen Coder │                                   │
│  │  • DeepSeek   │    ┌───────────────────────────┐  │
│  │               │◄───│  Aider                    │  │
│  │               │    │  (Terminal Coding Agent)   │  │
│  │               │    └───────────────────────────┘  │
│  │               │                                   │
│  │               │    ┌───────────────────────────┐  │
│  │               │◄───│  Open WebUI (optional)    │  │
│  │               │    │  (Chat Interface)         │  │
│  └──────────────┘    └───────────────────────────┘  │
│                                                     │
│          ⚡ All local. No internet needed. ⚡        │
└─────────────────────────────────────────────────────┘
```

---

*Setup created April 2026. Models and tools are actively maintained — update periodically when online.*
