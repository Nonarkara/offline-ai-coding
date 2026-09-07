# Guardrails

Rules for running this stack on a machine you own. Written for learners (Thai and English) and for agents that read `AGENTS.md`.

## Two paths, two trust models

| Path | Data | When |
|------|------|------|
| **Local** — Ollama `localhost:11434` | Stays on the Mac | Default. Planes, private code, after the first download |
| **OpenRouter** — `https://openrouter.ai/api/v1` | Prompt leaves the machine | Optional, online, rate-limited free (or paid) models |

Never label the second path “offline.” Mixing them in one VS Code window is fine; mixing the **claim** is not.

## Secrets

- Keys live in `~/.continue/.env`, your shell, or `~/.local/share/opencode/auth.json`.
- This git repo only has **empty** `*.example` files.
- `.gitignore` ignores `.env`, `.continue/`, `.ollama/`, and OpenCode auth.
- Continue inside VS Code **does not** see `export OPENROUTER_API_KEY` from Terminal. Use `~/.continue/.env`.
- If a PR, gist, or chat log would only work by pasting a key, stop.

Scan before you push a personal fork:

```bash
rg -n "sk-or-v1-|OPENROUTER_API_KEY=sk|sk-ant-|sk-proj-" --glob '!.git'
```

If something leaked, rotate the key on the provider first, then remove it from git history.

## Telemetry and sharing

- Continue: `"allowAnonymousTelemetry": false` (installer JSON) / do not turn it on in YAML.
- OpenCode example: `"share": "disabled"`.
- Do not paste proprietary code into Open WebUI if that instance is bound beyond localhost.
- Ollama should stay on loopback unless you **intend** a LAN fabric and understand bind + auth. This public installer does not open `0.0.0.0` for you.

## Agent permissions

OpenCode’s default is **allow everything**. The example config requires **ask** on edits and shell, **deny** on `rm -rf` and `sudo`. Copy [`examples/AGENTS.md`](../examples/AGENTS.md) into **your** project.

Aider example sets `auto-commits: false`. You commit.

Continue local models in the installer disable tool-calling (`capabilities.tools: false`) because small local models hallucinate tool JSON. Cloud models may set `tool_use` only if the slug actually supports tools.

## Ollama context (silent truncation)

The daemon default is **4096** tokens of context regardless of the model card. OpenCode / Continue / Cline `contextLength` does not override it. Fix:

```bash
launchctl setenv OLLAMA_CONTEXT_LENGTH 16384   # 16GB class
# then quit and reopen Ollama.app
launchctl getenv OLLAMA_CONTEXT_LENGTH
```

Too high on 8–16GB → “model requires more system memory” or heavy swap. Lower it. See [OPENCODE.md](OPENCODE.md).

## What not to send to OpenRouter

- `.env`, PEM files, `auth.json`, session cookies, production dump
- Other people’s unpublished data
- Anything you would not put in a third-party web chat

Prefer `data_collection: deny` and skip `:free` cards that disclose training on free traffic.

## Hardware honesty (studio machines)

This studio actually runs local models on:

- **M3 MacBook Air, 16GB** — always-on class machine; installer **16GB tier** (`qwen2.5-coder:14b` + 7B complete). It is **tight**. If macOS swap storms, drop chat size or context; do not pretend it is a 64GB box.
- **M5 Max, 128GB** — desk inference; installer **64GB+ tier** (`qwen2.5-coder:32b` + 7B complete + 14B reasoning). Optional extra pulls (`ollama pull`) are yours; they are not in the default script.

Those two machines are also described in public studio notes ([Axiom](https://github.com/Nonarkara/Axiom), [local-ai-fabric](https://github.com/Nonarkara/dr-non-vibecoding-skills/blob/main/skills/local-ai-fabric/SKILL.md)). This repo does **not** ship the private LAN gateway or Tailscale scripts from that fabric.

## Git and reviews

- Generated code is a draft. Run tests. Read the diff.
- Do not force-push `main`.
- Do not commit `~/.continue/config.yaml` with a live key (the YAML template uses `${{ secrets.… }}` on purpose).

## Contributions to this repo

Same as [CONTRIBUTING.md](../CONTRIBUTING.md), plus: no new “live demo” URLs, no invented tokens/sec, no API keys in fixtures, no “Axiom Thailand LLC.”
