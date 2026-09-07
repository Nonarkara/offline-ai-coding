# OpenCode

OpenCode is an open-source coding agent (TUI, desktop app, IDE extension). This repo wires it to **local Ollama** and, optionally, **OpenRouter free models**. It is a sibling of Continue (VS Code) and Aider (CLI) — not a replacement for the installer.

Official docs: [install](https://opencode.ai/docs) · [config](https://opencode.ai/docs/config) · [providers](https://opencode.ai/docs/providers) · [permissions](https://opencode.ai/docs/permissions) · [OpenRouter cookbook](https://openrouter.ai/docs/cookbook/coding-agents/opencode-integration)

## Install

Pick one (current official methods):

```bash
# Homebrew (macOS / Linux)
brew install anomalyco/tap/opencode

# npm
npm install -g opencode-ai

# script
curl -fsSL https://opencode.ai/install | bash
```

Desktop (optional): `brew install --cask opencode-desktop`

The installer in this repo can install the CLI if you say yes. You can also run `bash scripts/apply-studio-configs.sh` after a manual install.

## Config files

| Path | Role |
|------|------|
| `~/.config/opencode/opencode.jsonc` | Your defaults (providers, permissions, default model) |
| `opencode.json` / `opencode.jsonc` in a git repo | Project overrides |
| `AGENTS.md` in a git repo | Instructions the agent should follow |
| `~/.local/share/opencode/auth.json` | Keys from `/connect` — **gitignored, never copy into a repo** |

Template: [`examples/opencode.jsonc`](../examples/opencode.jsonc). Schema: `https://opencode.ai/config.json`.

OpenCode **does not auto-discover** Ollama tags. Every local model you want in `/models` must be listed under `provider.ollama.models` with the **exact** `ollama list` name (`qwen2.5-coder:14b`, not a display title).

## Local (offline after models are on disk)

1. Ollama running: `curl -s http://localhost:11434` should say it is running.
2. Copy the example config; set `"model": "ollama/<your-chat-tag>"` to match your RAM tier (see [HARDWARE.md](HARDWARE.md)).
3. If OpenCode asks for a key on the custom Ollama provider: `/connect` → Other → provider id `ollama` → any non-empty placeholder. Ollama does not validate it.
4. `cd` into a project and run `opencode`. `/models` → pick an `ollama/…` model.

Ollama’s OpenAI-compatible base URL is `http://localhost:11434/v1` — the `/v1` suffix is required in OpenCode.

### Context length (M3 and M5)

Ollama **defaults the daemon to 4096 context** even when the model card claims more. Setting `contextLength` in OpenCode, Continue, or Cline does **not** override that. Agents then truncate or “forget” the repo mid-task with no loud error.

On macOS, after install:

```bash
launchctl setenv OLLAMA_CONTEXT_LENGTH 16384   # 16GB class, e.g. M3 Air
# 32768 or 65536 only if you have RAM to spare (32GB+ / M5 Max class)
```

Then **fully quit Ollama.app** and reopen it. Check: `launchctl getenv OLLAMA_CONTEXT_LENGTH`.

`export` in `~/.zprofile` only affects `ollama serve` started from that shell — not the menu-bar app. Too large a value on a 16GB machine will swap or fail with “model requires more system memory”; drop it (Continue’s own Ollama guide uses 2048 as a recovery value).

This is the same lesson used on the studio’s M3 Air (16GB, often always-on) and M5 Max (128GB): the small machine keeps a conservative context; the large machine can raise it.

## OpenRouter (online, free models)

This path **is not offline**. Code in the prompt leaves your machine.

1. Create a key at [openrouter.ai/keys](https://openrouter.ai/keys) (prefix `sk-or-v1-…`).
2. In the TUI: `/connect` → OpenRouter → paste the key. Desktop: Settings → Providers → OpenRouter.
3. `/models` and pick a slug, or set `"model": "openrouter/cohere/north-mini-code:free"` in config.
4. Extra slugs go under `provider.openrouter.models` in the JSONC. Use the **exact** OpenRouter id.

Starter free slugs (catalog **changes**; confirm on [openrouter.ai/models?q=free](https://openrouter.ai/models?q=free)):

| Slug | Why it is in the example |
|------|--------------------------|
| `openrouter/free` | Official free-model router |
| `google/gemma-4-31b-it:free` | Open-weight Gemma 4 instruct |
| `cohere/north-mini-code:free` | Coding/agent model; OpenRouter notes OpenCode among harnesses |
| `nvidia/nemotron-3.5-lightning:free` | Small MoE, high-throughput |

Do **not** treat Poolside Laguna `:free` cards as private: their model cards say free use may train on inputs. Prefer `data_collection: deny` in account [privacy settings](https://openrouter.ai/settings/privacy) and see [OPENROUTER.md](OPENROUTER.md).

Limits (OpenRouter’s own free-tier docs, check if they move): **50 requests/day** until you have purchased credits; **20 requests/minute**; **429s still count**. Failed calls still burn quota.

## Permissions (learners)

OpenCode defaults to **allow**. The example config does the opposite for destructive work:

- `edit` and most `bash`: **ask**
- `rm -rf *` and `sudo *`: **deny**
- `git status/diff/log`, `ls`, `pwd`: **allow**
- `share`: **disabled** (no accidental session links)

`--auto` auto-approves asks except explicit denies. Do not use `--auto` on a repo you do not trust.

Copy [`examples/AGENTS.md`](../examples/AGENTS.md) into **your** project so the agent sees the same rules.

## Daily loop

```bash
ollama list                 # local tags
cd ~/Projects/my-app
opencode                    # TUI
# /models  → ollama/… when offline
# /models  → openrouter/… when you need a free cloud model
```

VS Code: install the OpenCode IDE extension from OpenCode’s docs if you want the same config inside the editor. Continue.dev remains the chat sidebar this installer configures (`Cmd+L`).

## What this is not

- Not Cursor, Claude Code, or Copilot.
- Not a hosted studio backend.
- Not permission to commit `auth.json`.
