<p align="center">
  <img src="docs/hero-banner.png" alt="Hand-drawn manga illustration of a mentor and a learner at one Mac in a rainy-night civic studio. Warm lamp, local box beside the laptop, city outside the window. No interface overlay." width="100%">
</p>

<p align="center"><em>Studio banner for this public repo — one Mac, local models, a civic studio at night. Illustration only; not a screenshot of the installer.</em></p>

# Offline AI Coding

**โค้ดด้วย AI บนเครื่องตัวเอง** · Code with AI on hardware you own.

[![License: MIT](https://img.shields.io/badge/license-MIT-1A1A1A)](LICENSE)

By [Non Arkaraprasertkul (Nonarkara)](https://github.com/Nonarkara) — [Axiom X Co., Ltd.](https://axiom.nonarkara.org), Bangkok.

**[Quick start](QUICKSTART.md)** · **[Hardware](docs/HARDWARE.md)** · **[Off the grid](OFF-THE-GRID-GUIDE.md)** · **[Troubleshooting](TROUBLESHOOTING.md)**

This repository is an installer and a method: one command that stands up a **local** AI coding stack on a machine you control. After the first download it does not need the internet. There is no hosted demo and no cloud account.

---

## What this is

A public setup for coding with open-weight models **on your own computer** — VS Code chat, tab autocomplete, and a terminal agent — without a monthly token bill and without sending your repo to a vendor.

`install.sh` detects OS, architecture, RAM, and free disk, then installs and wires:

| Piece | Role |
|-------|------|
| **Ollama** | Local model runtime (auto-start on boot where the installer can set it) |
| **Chat / complete / reason models** | Sized from your RAM (see [How to use](#how-to-use--learn)) |
| **VS Code + Continue.dev** | Editor chat (`Cmd+L` / `Ctrl+L`) and tab complete, pointed at `localhost` |
| **Aider** | Terminal agent via the `aider-offline` alias |
| **Open WebUI** | Optional browser chat (`webui-start` → `http://localhost:8080`) |
| **Kyutai Pocket TTS** | Optional offline voice (`speak`); skipped unless you say yes |

It also repairs the shell `PATH` — the failure mode the troubleshooting notes treat as the usual “command not found” cause.

**This repo is not** a hosted coding assistant, a model zoo with private weights, or a ranking of tools. It is the **method**: hardware detection, public model IDs, and the scripts that connect them. Fork that. Do not expect secrets, API keys, or a live URL.

Internet is required **once**, to fetch Homebrew/Ollama, models, and extensions. After that the models live under `~/.ollama`. Related notes: [QUICKSTART.md](QUICKSTART.md), [OFF-THE-GRID-GUIDE.md](OFF-THE-GRID-GUIDE.md), [docs/HARDWARE.md](docs/HARDWARE.md).

---

## Philosophy

Written for learners who land from the [Nonarkara](https://github.com/Nonarkara) profile — **Thai and English** readers equally. The studio is one desk in Bangkok, not a platform company.

1. **Fork the method, not the secrets.** The value is the installer, the RAM tiers, and the local wiring. There is nothing to hoard: no tokens in this tree, no private endpoint, no “enterprise edition.” If you take the scripts and ship a better stack, that is the point.
2. **One Mac.** The intended home is a single machine you own — Apple Silicon is where the notes are strongest (unified memory). The same scripts also try Linux and mention Windows via WSL2; those paths are still being proven. You do not need a cluster.
3. **No black-box rankings.** The installer does not sell a league table of models. It picks sizes from RAM and writes the IDs into Continue and Aider. The mapping is in `install.sh`. If a smaller box gets Gemma 4 E4B instead of Qwen 7B, the reason is in that file (MatFormer nesting, Ollama 0.22+), not a hidden score.
4. **Own the tools; rent nothing after setup.** Models on disk cannot be repriced or withdrawn the way an API can. Continue is configured with `allowAnonymousTelemetry: false`.
5. **Clear instructions beat a demo.** Step-by-step, as if the reader is new. Knowledge is not the paywall.

Company of record: **Axiom X Co., Ltd.** Author: **Non Arkaraprasertkul (Nonarkara)**. This public repo is studio method, not a billed Axiom product.

---

## Ethical use

Treat this as a **local workshop**, not a substitute for judgment, and not a license to dump other people’s work into a model you do not control.

**Do**

- Keep the stack on **localhost**. After setup, chat and complete should hit Ollama on your machine (`http://localhost:11434` in the Continue config the installer writes).
- Read each model’s own licence (Qwen, Gemma, DeepSeek, and anything you `ollama pull` later) before commercial use. This repo’s MIT grant covers **these scripts and docs**, not upstream weights.
- Review generated code. A local model is still a model.
- Leave credentials out of git. `.gitignore` already ignores `.continue/` and `.ollama/`.
- Say so if you publish a fork. Do not present a restyled installer as the official Nonarkara stack.

**Do not**

- Treat “offline forever” as “never download again” during the **first** install — the one-liner needs the network.
- Invent a live product URL, a leaderboard, or a quality score this repo does not measure.
- Commit API keys, tokens, or someone else’s Continue/Ollama user config.
- Imply this is Claude, Copilot, or Cursor, or that it is an official depa / municipal / UN tool. It is independent studio work.
- Point the same machine at a cloud provider and call the result “offline.”

If a contribution only works by pasting a secret, it does not belong here.

---

## How to use / learn

**Best path today:** macOS (Apple Silicon fully exercised in the notes; Intel tested with Rosetta). Ubuntu 22.04+ and Windows 11 WSL2 are listed as in progress — try them, file what breaks.

**Minimum:** 8 GB RAM, a current CPU, tens of GB free (the installer warns under 40 GB). **Comfortable:** 32 GB+ Apple Silicon. Exact tier tables: [docs/HARDWARE.md](docs/HARDWARE.md).

### Install

One-liner (needs network this once):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Nonarkara/offline-ai-coding/main/install.sh)
```

Or clone and run:

```bash
git clone https://github.com/Nonarkara/offline-ai-coding.git
cd offline-ai-coding
chmod +x install.sh
./install.sh
```

Then open a **new** terminal so `PATH` and aliases load.

What the script does, in order: detect hardware → fix `PATH` → Homebrew → Ollama (upgrade if Gemma 4 needs 0.22+) → pull models → VS Code if missing → Continue.dev + `~/.continue/config.json` → Aider + `aider-offline` → optional Open WebUI → optional Pocket TTS → a short verify.

Downloads dominate the wait (the docs say on the order of half an hour). Re-run if a pull drops; already-present models are skipped.

### RAM → models (`install.sh`)

| RAM | Chat | Autocomplete | Reasoning |
|-----|------|--------------|-----------|
| 64 GB+ | `qwen2.5-coder:32b` | `qwen2.5-coder:7b` | `deepseek-r1:14b` |
| 32 GB | `qwen2.5-coder:32b` | `qwen2.5-coder:7b` | `deepseek-r1:7b` |
| 16 GB | `qwen2.5-coder:14b` | `qwen2.5-coder:7b` | `deepseek-r1:7b` |
| 8 GB | `gemma4:e4b` | `qwen2.5-coder:3b` | `deepseek-r1:1.5b` |
| under 8 GB | installer exits | | |

8 GB uses Gemma 4 E4B because the script treats it as a better fit than another dense 7B on that budget. You can add models later with `ollama pull`.

### Daily loop

1. Ollama should already be up (menu bar app, `brew services`, or `ollama serve`).
2. Open a project in VS Code → **Cmd+L** / **Ctrl+L** → ask in plain language. Tab accepts complete.
3. Or: `cd` into a git repo and run `aider-offline`.
4. Optional: `webui-start` then `http://localhost:8080`. Optional: `speak --text "…" --voice default`.
5. Work offline. Push when you are back on a network.

Worked examples: [QUICKSTART.md](QUICKSTART.md). When something fails: [TROUBLESHOOTING.md](TROUBLESHOOTING.md), then `bash scripts/verify.sh`. Extra Mac-oriented narrative: [OFF-THE-GRID-GUIDE.md](OFF-THE-GRID-GUIDE.md). Other scripts in the tree (`setup-offline-coding.sh`, `install-main.sh`, `start-coding.sh`, `fix-continue-config.sh`) are older or helper copies — **`install.sh` is the current installer.**

---

## System diagram

```mermaid
flowchart LR
    You[You] --> VS[VS Code]
    You --> Aid[Aider]
    You --> Web[WebUI]
    VS --> Ol[Ollama]
    Aid --> Ol
    Web --> Ol
    Ol --> Disk[Local models]
```

```mermaid
flowchart LR
    Sh[install.sh] --> Ram[RAM detect]
    Ram --> Pull[ollama pull]
    Pull --> Cfg[Continue + aliases]
    Cfg --> You[Your machine]
```

Everything after install is on-box. No studio backend.

---

## License / contributing

[MIT](LICENSE). Copyright © 2026 **Non Arkaraprasertkul / Axiom X Co., Ltd.**

MIT covers this repository’s scripts and documentation. Ollama, VS Code, Continue.dev, Aider, Open WebUI, Pocket TTS, and each model keep their own licences.

Help that is actually useful: Linux and WSL2 test reports, GPU notes (CUDA / ROCm), translations, and clearer docs. See [CONTRIBUTING.md](CONTRIBUTING.md). Bug reports: what you ran, the exact error, RAM / CPU / OS, `ollama list`, and `echo $PATH`.

The hero at `docs/hero-banner.png` is studio illustration for this README, not a data product.

If this setup lets you work without a token meter, teach the next person. If you build on the method, say so — the studio wants to see it.
