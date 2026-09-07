# Project guardrails (for OpenCode, Continue, Aider, Cursor)

Copy this file to the **root of the repo you are working in**, not into this installer repo unless you mean to constrain contributors here.

You are a coding agent on a machine the human owns. Prefer the **local Ollama** model when it is available. Use OpenRouter only when the human asked for a cloud/free model and they have a key.

## Do

- Read existing files before editing. Match the project's language, layout, and tests.
- Keep secrets out of git: `.env`, `auth.json`, API keys, Continue user config.
- For OpenRouter: treat prompts as leaving the machine. Do not paste credentials, `.env`, or private client data into the chat.
- Ask before `git push`, `git reset --hard`, deleting files, or installing global packages.
- After a non-trivial change, run the project's tests or the smallest command that would catch a break.

## Do not

- Call a cloud model "offline."
- Invent live URLs, metrics, awards, or API keys.
- Enable telemetry, share session links, or upload the repo to a vendor.
- Run `rm -rf`, `sudo`, or rewrite git history unless the human typed that request.
- Commit `~/.continue/`, `~/.ollama/`, `~/.local/share/opencode/auth.json`, or filled `.env` files.

## Models

- Local: Ollama at `http://localhost:11434` (OpenAI-compatible at `/v1`).
- Online free: OpenRouter slugs ending in `:free`, or `openrouter/free`. Catalog changes; confirm on https://openrouter.ai/models?q=free
- If Ollama truncates mid-task with no error, the daemon may still be on a 4096 context. See `docs/GUARDRAILS.md` in [offline-ai-coding](https://github.com/Nonarkara/offline-ai-coding).
