# Offline AI Coding

**Stop paying for tokens. Stop waiting for internet. Code with AI — completely offline — on your own hardware.**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/nonarkara/offline-ai-coding/main/install.sh)
```

One command. 30 minutes. Then you have Claude Code / Cursor / Copilot — but free, private, and offline forever.

---

## Why This Exists

The old model is broken. Vendors lock their AI behind subscriptions, NDAs, and six-figure enterprise fees. They sell you a black box. You wait months for a demo, years for deployment. By the time it arrives, the technology is obsolete.

This project does the opposite.

We built it. Then we pushed the code to GitHub. Anyone can take it. Fork it. Break it. Make it better. We don't care if they compete with us. We care that they stop waiting for permission.

**The rules are simple:**

- **Share everything.** Source code, install scripts, configuration, prompts. No hidden modules. No "enterprise edition."
- **Write clear instructions.** Tell people how to run it on their own laptop, their own cloud, their own city. Step by step. Like they're five.
- **Don't hoard knowledge.** The value isn't in the code. The value is in knowing what problem to solve.
- **Let people steal from you.** If someone takes this and builds a product, good for them. We'll build a better version tomorrow.

GitHub is our weapon. Open source is our revolution.

Take it. Use it. Break it. Tell us what you built.

---

## The Problem

You're probably here because one (or more) of these describes you:

1. **Token costs are killing you.** Claude, Gemini, ChatGPT, Copilot — $20/month here, $10/month there. You code a lot. It adds up fast.

2. **You work offline.** Planes, trains, remote cabins, developing countries, rural areas, coffee shops with garbage WiFi. You need AI coding assistance but can't rely on internet.

3. **You care about privacy.** Your code shouldn't live on someone else's servers. You want everything local.

4. **You want to own your tools.** APIs change pricing. Services shut down. Terms of service shift. You want something that's *yours*.

5. **You're tired of configuration hell.** You tried Ollama or local LLMs but spent hours fighting PATH variables, broken configs, and mysterious errors. You just want it to *work*.

This project solves all five. One command, and you have a complete, production-ready offline AI coding stack.

---

## What You Get

### AI Models Running Locally

| Model | Size | What It Does |
|-------|------|-------------|
| **Qwen 2.5 Coder 32B** | 19GB | Your main coding brain on 32GB+ machines. Benchmarks near GPT-4o. 200+ languages. |
| **Gemma 4 E4B** | ~9.6GB | Main coding brain on **8GB** machines. MatFormer-nested — only ~4.5B params active per token despite the larger download, so it fits a tight RAM budget. Multimodal, up to 256K context. |
| **Qwen 2.5 Coder 7B** | 4.7GB | Real-time autocomplete as you type. |
| **DeepSeek R1 14B** | 9GB | Complex reasoning and debugging. |

The installer auto-detects your RAM and chooses model sizes that fit. You don't have to decide anything.

**Why Gemma 4 E4B on the 8GB tier instead of another Qwen model:** the "E4B" name is Google's MatFormer nesting — the ~8B-parameter download only activates ~4.5B params per token, so quality-per-GB beats a same-footprint dense model. It also needs **Ollama 0.22+**; the installer checks and upgrades automatically if you're behind.

### VS Code + AI Chat (Like Cursor / Copilot)

Open VS Code. Press **Cmd+L** (Mac) or **Ctrl+L** (Linux/Windows). Chat with your AI in plain English:

- *"Create a React component for a dashboard"*
- *"Add TypeScript types to all functions"*
- *"Fix the error on line 23"*
- *"Refactor this to use hooks"*

Press **Tab** for autocomplete suggestions as you type. It looks and feels like Cursor or GitHub Copilot — but it runs entirely on your machine.

### Aider Terminal Agent (Like Claude Code)

For when you want an AI that reads your whole project and makes changes across multiple files:

```bash
cd ~/my-project
aider-offline
```

Then just chat:

```
> Add dark mode support to the entire app
> Create a REST API with authentication
> Refactor the database layer to use Prisma
> Fix all TypeScript errors
```

Aider reads your codebase, edits files, and auto-commits to git. It's like having a developer working alongside you in the terminal.

### Open WebUI (Like ChatGPT — Optional)

A browser-based chat interface for brainstorming, planning, and asking questions:

```bash
webui-start
# Then open http://localhost:8080
```

### Voice — Kyutai Pocket TTS (Optional)

Offline text-to-speech, for having your AI read code reviews, changelogs, or long
responses out loud instead of scrolling:

```bash
speak --text "the build passed" --voice default
```

**Why Kyutai over VoiceBox:** VoiceBox was published as a Meta research paper and
demo — never released as weights you can actually download and run. Kyutai's
[Pocket TTS](https://github.com/kyutai-labs/pocket-tts) is a real open-weight
model: 100M parameters, real-time on CPU, no GPU required, with voice cloning
from a short wav sample. That's the bar for anything in this repo — if you
can't `pip install` it and run it fully offline, it doesn't belong here.

Skipped by default (prompted during install, default: no) since it's not core
to coding. Install later anytime: `pip3 install pocket-tts`.

---

## Hardware Requirements

| RAM | Experience | Models You Get |
|-----|-----------|---------------|
| **8GB** | Works (slower) | Gemma 4 E4B + DeepSeek 1.5B |
| **16GB** | Good | Qwen 14B + DeepSeek 7B |
| **32GB** | Excellent | Qwen 32B + DeepSeek 14B |
| **64GB+** | Best possible | Everything, full speed |

**Minimum:** 8GB RAM, any modern CPU, 40GB free disk space.

**Best:** Apple Silicon Mac (M1/M2/M3/M4) with 32GB+ RAM. The unified memory architecture makes local LLMs fly.

The installer detects your hardware and tells you exactly what's possible.

See [HARDWARE.md](docs/HARDWARE.md) for detailed compatibility.

---

## Installation

### The One-Liner

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/nonarkara/offline-ai-coding/main/install.sh)
```

### What It Does (Automatically)

1. **Detects your hardware** — OS, CPU, RAM, architecture, free disk space
2. **Fixes your shell PATH** — the #1 cause of "command not found" errors
3. **Installs Homebrew** — package manager (if needed)
4. **Installs Ollama** — local AI model runtime
5. **Downloads AI models** — auto-selects sizes based on your RAM
6. **Installs VS Code** — if not already present
7. **Configures Continue.dev** — VS Code extension for AI chat
8. **Installs Aider** — terminal coding agent
9. **Sets up auto-start** — Ollama launches on boot
10. **Tests everything** — verifies models work end-to-end

**Time:** 30-45 minutes (mostly downloading models). You only do this once.

**Internet:** Required for this initial setup. After that, never again.

### Alternative: Clone and Run

```bash
git clone https://github.com/nonarkara/offline-ai-coding.git
cd offline-ai-coding
chmod +x install.sh
./install.sh
```

---

## Usage

### Daily Workflow

1. **Open VS Code** (Ollama auto-starts on boot — no setup needed)
2. **Open your project folder** (File → Open Folder)
3. **Press Cmd+L** to chat with AI
4. **Code in plain English**

That's it. No terminal. No configuration. No internet.

### New Project

```bash
mkdir ~/Projects/my-app && cd ~/Projects/my-app && git init
code .
# Press Cmd+L → "Create a Next.js app with TypeScript and Tailwind"
```

### Existing GitHub Project

```bash
# Clone while online
git clone https://github.com/your/repo.git
cd repo

# Code offline anytime
code .
# Press Cmd+L → "Add authentication to the API endpoints"
```

### Terminal Agent

```bash
cd ~/Projects/my-app
aider-offline
# > "Refactor the entire state management layer"
```

### Push When Back Online

```bash
git add -A && git commit -m "Added features offline" && git push
```

See [QUICKSTART.md](QUICKSTART.md) for detailed workflows.

---

## What Makes This Different

### vs. "Just Install Ollama"

Ollama alone doesn't give you IDE integration, auto-configuration, PATH fixes, or a terminal agent. This project automates everything that usually takes hours of debugging.

### vs. Claude / ChatGPT / Copilot ($20+/month)

- ✅ Zero monthly cost
- ✅ Works offline
- ✅ Your code stays on your machine
- ✅ No vendor lock-in
- ✅ No rate limits

### vs. Cursor ($20/month)

- ✅ Free forever
- ✅ Works offline
- ✅ Open source
- ✅ You control the models
- ✅ No telemetry

### vs. Self-Hosting LLMs

- ✅ Pre-configured — no YAML files to edit
- ✅ Hardware auto-detection
- ✅ IDE integration included
- ✅ Troubleshooting guide included
- ✅ Works on first try

---

## Supported Platforms

| Platform | Status |
|----------|--------|
| macOS (Apple Silicon M1-M4) | ✅ Fully tested |
| macOS (Intel) | ✅ Tested (requires Rosetta) |
| Ubuntu 22.04+ | 🟡 In progress |
| Windows 11 (WSL2) | 🟡 In progress |
| Other Linux distros | 🟡 Community contributions welcome |

---

## FAQ

**Is this legal?**
Yes. All software (Ollama, Qwen, DeepSeek, Continue.dev, Aider) is open source under permissive licenses. This project is MIT-licensed.

**Is it really as good as Claude/GPT-4?**
Qwen 2.5 Coder 32B benchmarks at 73.7 on the Aider coding benchmark — within striking distance of GPT-4o. For most coding tasks, you won't notice the difference.

**How much does it cost?**
Zero. Open-source software on hardware you already own. If you need to upgrade RAM, that's a one-time cost.

**Can I use this commercially?**
Yes. Check individual model licenses (Qwen and DeepSeek both allow commercial use).

**What if my computer is too old?**
Even 8GB RAM machines can run 7B models. It's slower but functional. See [docs/HARDWARE.md](docs/HARDWARE.md).

**Can I add more models later?**
Absolutely:
```bash
ollama pull codestral:22b    # Mistral's coding model
ollama pull llama3:70b       # Meta's general model
```

---

## Project Structure

```
offline-ai-coding/
├── README.md                  ← You're here
├── QUICKSTART.md              ← 5-minute setup guide
├── TROUBLESHOOTING.md         ← Every problem + solution
├── install.sh                 ← The main installer
├── scripts/
│   ├── fix-path.sh           ← PATH repair utility
│   └── verify.sh             ← Installation tester
├── docs/
│   ├── HARDWARE.md           ← Hardware requirements
│   ├── MODELS.md             ← Model details and benchmarks
│   ├── CONFIGURATION.md      ← Customization guide
│   └── FAQ.md                ← Extended FAQ
├── .github/
│   └── ISSUE_TEMPLATE/       ← Bug report templates
├── CONTRIBUTING.md            ← How to help
└── LICENSE                    ← MIT
```

---

## Contributing

We want this to work on every platform, for every developer.

**Areas we need help:**
- Linux testing (Ubuntu, Fedora, Arch)
- Windows WSL2 support
- GPU acceleration (NVIDIA CUDA, AMD ROCm)
- Documentation and video walkthroughs
- Model benchmarking
- Internationalization

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## The Philosophy

> *"Every line of code I write is a middle finger to the old guard. To the $935 paywalls. To the 'platinum certifications.' To the consultants who gatekeep knowledge."*

This project exists because we believe:

1. **AI coding tools should be free.** The models are open source. The tools are open source. The setup should be too.

2. **Knowledge should be shared.** No hidden modules. No enterprise edition. Everything is public.

3. **Developers deserve independence.** You shouldn't need a subscription to write code. You shouldn't need internet to think.

4. **The best tools are owned, not rented.** When you run this, the models live on your machine. They can't be taken away, repriced, or shut down.

If this saves you money, time, or frustration — share it with someone else.

If you build something with it — tell us. We want to know.

---

## License

MIT. Use, modify, distribute freely. See [LICENSE](LICENSE).

---

## Star This Repo

If this helped you, star it. It helps others find it.

If you have ideas, open an issue. If you have code, open a PR.

**Let's make offline AI coding accessible to everyone.**

---

*Built by [nonarkara](https://github.com/nonarkara) — city systems designer, anthropologist, and advocate for open knowledge. April 2026.*
