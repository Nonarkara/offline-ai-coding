# Quick Start — Offline local, optional OpenRouter

**TL;DR:** Run the installer once (needs network). After that, **Ollama is local**. OpenRouter free models are a **separate, online** option.

Canonical clone: `https://github.com/Nonarkara/offline-ai-coding`

---

## Installation (One Command)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Nonarkara/offline-ai-coding/main/install.sh)
```

That's it. The script:
1. Detects your hardware and sets `OLLAMA_CONTEXT_LENGTH`
2. Installs Ollama and pulls RAM-tier models
3. Configures VS Code + Continue.dev (JSON + YAML)
4. Installs Aider (`aider-offline`, `aider-openrouter`)
5. Optionally installs OpenCode
6. Tests Ollama

**Total:** tens of minutes (mostly downloads) for the local stack.

Already installed? `bash scripts/apply-studio-configs.sh` from a clone.

---

## Your First 5 Minutes of Coding

### Using VS Code (Recommended)

1. **Open VS Code** (Cmd+Space → "Visual Studio Code" → Enter)
2. **Open a folder** (File → Open Folder → any folder you want to code in)
3. **Press Cmd+L** (Mac) or **Ctrl+L** (Windows/Linux)
4. **Chat with the AI:**
   ```
   Create a React component for a dashboard with 3 metric cards
   ```
5. Watch it write code. See the diff. Accept it. Done.

**Repeat** for any coding task:
- "Add TypeScript types to all functions"
- "Create an API endpoint for user authentication"
- "Fix the error on line 42"
- "Refactor to use hooks instead of class components"

### Using Aider (Terminal Agent)

If you prefer a terminal experience (like Claude Code):

```bash
cd ~/your-project
aider-offline
```

Then just chat:
```
Add dark mode support to the dashboard
Fix the TypeScript errors
Create a new component for displaying user profiles
Refactor the state management to use Zustand
```

### Using OpenCode (TUI)

```bash
cd ~/your-project
opencode
```

`/models` → pick `ollama/<tag>` from `ollama list`. Permissions in the example config **ask** before edits and shell. Copy `examples/AGENTS.md` into the project. Full guide: [docs/OPENCODE.md](docs/OPENCODE.md).

### OpenRouter free models (online — not offline)

1. Create a key at https://openrouter.ai/keys
2. VS Code: `~/.continue/.env` with `OPENROUTER_API_KEY=` (Continue does not read zsh `export`)
3. CLI: `export OPENROUTER_API_KEY=…` then `aider-openrouter` or `opencode` → `/connect`
4. Keep **tab autocomplete** on local Qwen so you do not burn the free daily cap
5. Expect 429s. Catalog: https://openrouter.ai/models?q=free

Full guide: [docs/OPENROUTER.md](docs/OPENROUTER.md). Guardrails: [docs/GUARDRAILS.md](docs/GUARDRAILS.md).

---

## Common Workflows

### Build a New Project From Scratch

```bash
# Create a new project
mkdir ~/my-project && cd ~/my-project && git init

# Start with Aider
aider-offline
```

Then tell it what you want:
```
Create a Next.js project with TypeScript and Tailwind CSS
```

It'll generate the whole project structure, install dependencies, create components — everything.

### Work With an Existing GitHub Project

```bash
# Clone your repo
git clone https://github.com/yourusername/my-repo.git
cd my-repo

# Open in VS Code
code .

# Or use Aider
aider-offline
```

Chat with it about your codebase:
```
What does the authentication flow do?
Add a new feature for user profiles
Fix the bug in the payment processing
Refactor this component to use TypeScript
```

### Iterative Development

```
> Create a dashboard with 4 cards
> Add TypeScript types
> Style with Tailwind CSS
> Make the cards clickable
> Add a modal that opens on click
> Add form inputs to the modal
> Connect to an API endpoint (placeholder)
```

Each step, the AI understands the previous context. It's truly conversational.

---

## Your Tools

| Tool | When to Use | How |
|------|------------|-----|
| **VS Code Chat (Cmd+L)** | Local chat + complete; optional OpenRouter in the dropdown | Open VS Code → Cmd+L |
| **Aider Terminal** | Whole-project edits, local | `aider-offline` |
| **Aider + OpenRouter** | Online free models | `aider-openrouter` (needs key) |
| **OpenCode** | TUI agent, local or OpenRouter | `opencode` then `/models` |
| **Open WebUI** | Browser chat | `webui-start` → http://localhost:8080 |

---

## Hardware Tiers

The script auto-detects your RAM and installs the best models for your hardware:

| Your RAM | What You Get | Speed | Quality |
|----------|------------|-------|---------|
| 64GB | Qwen 32B + reasoning models | ~10 tokens/sec | Best (near GPT-4o) |
| 32GB | Qwen 32B + reasoning | ~10 tokens/sec | Best (near GPT-4o) |
| 16GB | Qwen 14B + reasoning | ~15 tokens/sec | Very good |
| 8GB | Qwen 7B + smaller models | ~30 tokens/sec | Good |

Larger models = better code quality. But even 7B is genuinely impressive for coding.

---

## After Installation

### First Time You Open VS Code

VS Code might ask about the Continue.dev extension. Click "Install" or just open VS Code normally. Continue is already configured to use your local models.

### First Time You Use Aider

Aider will ask if you want to create a git repo. Say yes (`y`). It tracks its changes automatically.

### If Models Don't Appear in VS Code Chat

1. Make sure Ollama is running (check for llama icon in menu bar, or run `ollama serve`)
2. Restart VS Code
3. See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) if it persists

---

## Disconnecting From the Internet

After setup, everything works offline. To confirm:

1. **Disconnect WiFi or unplug ethernet**
2. **Open VS Code**
3. **Press Cmd+L and chat**

It works. Models run locally. No internet needed.

---

## Costs

- **Setup:** Zero (all free, open-source software)
- **Monthly:** Zero (runs on your hardware)
- **Total cost of ownership:** One-time hardware cost if you need to upgrade your computer

Compare to: $20/month Claude, $20/month Copilot, $0.03/1k tokens Gemini. This saves money immediately if you code regularly.

---

## Is It Really Offline?

**Yes.** After the initial model download:
- Ollama runs locally
- Models are on your disk
- VS Code talks to Ollama via localhost
- Aider works entirely locally
- No data leaves your computer

You can:
- Disconnect from the internet
- Code for hours
- Reconnect when done
- Push to GitHub

Your code stays on your machine until you explicitly push it.

---

## What If Something Goes Wrong?

Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md). We've hit every problem and documented the solutions.

Common issues:
- **"Model not found"** → Ollama might not be running. Run `ollama serve`.
- **"Continue.dev won't connect"** → Restart VS Code. Check Ollama is running.
- **"Installation interrupted"** → Re-run the script. It resumes from where it left off.
- **"My computer is too old/slow"** → See [HARDWARE.md](HARDWARE.md) for minimum specs.

---

## Next Steps

1. **Run the installer** (one command, above)
2. **Wait for models to download** (30-45 minutes, then you're done)
3. **Open VS Code and press Cmd+L**
4. **Start coding**

That's it. You've got your own Claude/Copilot equivalent, forever, on your machine.

---

**Questions?** See [README.md](README.md) for the full story, [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for solutions, or open an issue on GitHub.

**Ready?** Run the installer:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Nonarkara/offline-ai-coding/main/install.sh)
```

Welcome. You're about to save a lot of money and gain a lot of freedom.
