# Offline AI Coding — The Open-Source Alternative to Paid Cloud AI

**Stop paying for tokens. Stop waiting for internet. Code with AI, completely offline, on your own hardware.**

This is a fully automated setup that gives you Claude-like AI coding assistance (through open-source models like Qwen), VS Code integration, and a terminal agent — all running locally on your computer. No cloud. No API keys. No subscriptions. No internet required after the initial download.

Think of it as deploying your own personal AI coding assistant that lives on your machine.

---

## The Problem This Solves

You're probably here because one of these describes you:

1. **Token costs are killing you.** You code a lot, and Claude/Gemini/ChatGPT monthly bills are adding up. You'd rather pay once for better hardware.

2. **You fly or travel offline a lot.** You need coding assistance but can't rely on internet stability. Coffee shops, airplanes, remote work — none of it have reliable connectivity.

3. **You care about privacy.** Your code shouldn't live on Anthropic's / Google's / OpenAI's servers. You want it all local.

4. **You want to own your tools.** Paid APIs can change terms, pricing, availability. You want something that's *yours*.

5. **You're frustrated with setup complexity.** You tried Ollama or local LLMs but the configuration was a nightmare. You need something that *just works*.

This repository solves all five. It's a production-ready, fully automated offline AI coding stack. You run one command, answer a few questions about your hardware, and you have VS Code with AI autocomplete and chat, plus a terminal agent (like Claude Code), all running on your machine.

---

## What You Get

### 1. **Three AI Models Installed Locally**

- **Qwen 2.5 Coder 32B** (19GB) — Your main coding brain. Benchmarks near GPT-4o quality. Knows 200+ programming languages.
- **Qwen 2.5 Coder 7B** (4.7GB) — Fast autocomplete suggestions. Runs in real-time as you type.
- **DeepSeek R1 14B** (9GB) — For complex reasoning and debugging. When you ask "why is this broken?" it breaks down the logic.

Each model was chosen because it's the best-in-class open-source alternative as of April 2026. We evaluated against CodeLlama, Mistral, and others. Qwen wins on quality.

### 2. **VS Code + Continue.dev Integration**

Open VS Code, press **Cmd+L** (Mac) or **Ctrl+L** (Windows/Linux), and chat with your AI:

- *"Create a React component for a dashboard card"* → AI writes it
- *"Add TypeScript types"* → AI refactors it
- *"Fix the error on line 23"* → AI debugs it
- Press **Tab** for autocomplete suggestions as you type

It looks and feels like Cursor or GitHub Copilot, but it's running entirely on your machine.

### 3. **Aider Terminal Agent**

For when you want an AI that reads your whole project and makes changes across multiple files:

```bash
cd ~/my-project
aider-offline
```

Then just chat:
- *"Add dark mode support to the dashboard"*
- *"Refactor the state management to use Zustand"*
- *"Create a new API endpoint for user authentication"*

Aider reads your codebase, makes changes, and automatically commits to git. It's like having a junior developer working with you.

### 4. **One-Click Setup**

The hardest part of this used to be:
- Installing Ollama
- Downloading models
- Configuring VS Code extensions
- Fixing broken PATH variables
- Handling different hardware specs

We've automated all of it. One command handles everything:

```bash
bash <(curl -s https://raw.githubusercontent.com/yourusername/offline-ai-coding/main/install.sh)
```

The script:
1. Detects your hardware (CPU, RAM, GPU)
2. Chooses appropriate model sizes
3. Installs Ollama
4. Downloads models (handles connection issues gracefully)
5. Configures VS Code
6. Fixes environment variables
7. Sets up auto-start
8. Tests everything

**Total time:** 30-45 minutes (mostly model downloads), then zero setup forever.

### 5. **Zero Internet After Setup**

After the initial download, you need zero internet:
- AI models run locally
- VS Code works offline
- Aider works offline
- Git integration works offline
- Everything stays on your machine

Fly. Travel. Go off-grid. Code anywhere.

---

## Who Is This For?

| Person | Why This Works |
|--------|---------------|
| **Freelance developers** | No monthly API costs. Bill clients per project, not per token. |
| **Digital nomads / travelers** | Works on planes, in rural areas, anywhere without stable internet. |
| **Privacy-conscious engineers** | Your code stays on your machine. No cloud. No logs. |
| **Researchers / academics** | Offline experimentation with cutting-edge models. Reproducible results. |
| **Teams with air-gapped networks** | Deploy on company hardware. No external API calls. |
| **Hobbyists on a budget** | One-time hardware cost instead of subscription fees. |

---

## Hardware Requirements

**Minimum (Works, but slower):**
- 16GB RAM
- Any Mac (Apple Silicon preferred), Windows, or Linux
- 30GB free disk space

**Recommended (Great experience):**
- 32GB+ RAM
- Apple Silicon Mac (M1/M2/M3/M4), high-end CPU, or GPU
- SSD with 40GB free space

**Why it matters:** More RAM = larger models = better code quality. We auto-detect your hardware and install the largest models that fit.

See [HARDWARE.md](HARDWARE.md) for detailed compatibility by machine type.

---

## Quick Start (5 Minutes)

**1. Download the installer:**

```bash
curl -O https://raw.githubusercontent.com/yourusername/offline-ai-coding/main/install.sh
chmod +x install.sh
./install.sh
```

**2. Answer a few questions** (hardware detection, confirm model sizes, etc.)

**3. Wait** (30-45 min for model downloads, then auto-installs everything)

**4. Done.** Open VS Code, press Cmd+L, start coding.

See [QUICKSTART.md](QUICKSTART.md) for more detail.

---

## What Happens Under The Hood

We do a lot to make this seamless:

1. **Hardware Detection** — Detects your OS, CPU, RAM, GPU. Chooses model sizes that fit.

2. **Dependency Management** — Installs Homebrew (Mac), checks for Python, sets up package managers.

3. **Model Selection** — Based on your RAM:
   - 16GB: Qwen 7B + DeepSeek 7B
   - 32GB: Qwen 32B + DeepSeek 14B
   - 64GB: Qwen 32B + DeepSeek 14B + experimental models

4. **Path Repair** — We've learned the hard way that broken shell PATH variables break everything. The installer proactively fixes this.

5. **Ollama Setup** — Downloads and configures Ollama (the runtime for models).

6. **Model Download** — Downloads AI models from Ollama registry. Handles interruptions — you can pause and resume.

7. **VS Code Integration** — Installs Continue.dev extension, auto-configures it to connect to your local models.

8. **Aider Setup** — Installs the terminal agent, creates convenient aliases.

9. **Auto-Start** — Makes Ollama launch on system boot (zero setup on reboot).

10. **Verification** — Tests everything end-to-end. If something fails, gives you clear debugging steps.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the technical details.

---

## Common Questions

**Q: Is this legal?**
A: Yes. Ollama, Qwen, and DeepSeek are open-source under permissive licenses. This project is MIT-licensed. Use freely, modify, redistribute.

**Q: Won't local models be slower than Claude?**
A: They're actually faster for most tasks. Running locally means no network latency. Qwen 32B is nearly as good as GPT-4o and runs at ~10 tokens/sec on a 32GB Mac. That's faster than waiting for an API response.

**Q: How much does this cost?**
A: Zero monthly costs. One-time hardware cost if you don't have a capable computer. Models are free and open-source.

**Q: Can I use this for commercial work?**
A: Yes. The models, tools, and this setup are licensed for commercial use. (Check individual model licenses for specifics — Qwen and DeepSeek allow commercial use.)

**Q: What if my computer isn't powerful enough?**
A: The installer detects your hardware and tells you what's possible. You can still run smaller models (Qwen 7B) even on 8GB RAM, though it'll be slower. See [HARDWARE.md](HARDWARE.md).

**Q: Can I contribute?**
A: Yes! See [CONTRIBUTING.md](CONTRIBUTING.md). We want this to work on every platform.

---

## Getting Started

1. **[QUICKSTART.md](QUICKSTART.md)** — 5-minute setup for impatient people
2. **[INSTALLATION.md](INSTALLATION.md)** — Detailed step-by-step walkthrough
3. **[ARCHITECTURE.md](ARCHITECTURE.md)** — How it all works under the hood
4. **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** — We've hit every problem. Solutions included.
5. **[USAGE.md](USAGE.md)** — How to actually code with the AI

---

## Why Open-Source?

We could have sold this as a paid product. Instead, we're open-sourcing it because:

1. **The problem is universal.** Millions of developers are stuck with token costs or offline constraints.

2. **Transparency builds trust.** You can see exactly what gets installed, where data goes, how it's configured.

3. **The community is better.** Someone using this on Linux will find issues we never tested. Someone on Windows will have ideas we didn't think of. Open-source scales.

4. **It's the right thing.** AI models are open-source (Qwen, DeepSeek). The tools are open-source (Ollama, VS Code, Continue.dev). This setup should be too.

---

## Project Status

**Current version:** 1.0 (April 2026)

**Tested on:**
- ✅ macOS 13+ (Apple Silicon M1, M2, M3, M4)
- ✅ macOS 13+ (Intel — requires Rosetta)
- 🟡 Linux (Ubuntu 22.04+) — in progress
- 🟡 Windows 11 (WSL2) — in progress

**Known limitations:**
- GPU support (NVIDIA CUDA) coming soon
- AMD GPU support in development
- Windows native (non-WSL) in progress

See [CONTRIBUTING.md](CONTRIBUTING.md) if you want to help expand platform support.

---

## License

MIT. Use, modify, distribute freely. See [LICENSE](LICENSE).

---

## Community

- **Found a bug?** [Open an issue](https://github.com/yourusername/offline-ai-coding/issues)
- **Have an idea?** [Start a discussion](https://github.com/yourusername/offline-ai-coding/discussions)
- **Want to contribute?** See [CONTRIBUTING.md](CONTRIBUTING.md)
- **Need help?** Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) or ask in Issues

---

## One More Thing

The reason we built this: we got tired of token costs and internet dependency. We wanted to own our tools. We wanted to code anywhere. We wanted a setup that actually worked without fighting configuration issues.

This project is that. It's what we wish existed when we started.

If it saves you money, time, or frustration — that's a win. If it helps you code offline or avoid vendor lock-in — even better.

Use it. Fork it. Improve it. Share it. The goal is a world where every developer can afford — and access — powerful AI coding assistance, anywhere, anytime.

---

**Ready?** Start with [QUICKSTART.md](QUICKSTART.md) or jump straight to `./install.sh`.

Welcome. You're going to love this.
