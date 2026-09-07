# Example configs

Templates for **your home directory**, not secrets.

| File | Copy to |
|------|---------|
| `opencode.jsonc` | `~/.config/opencode/opencode.jsonc` |
| `continue.config.yaml` | `~/.continue/config.yaml` (this **replaces** `config.json` if present) |
| `continue.env.example` | `~/.continue/.env` then add the key |
| `aider.conf.yml` | `~/.aider.conf.yml` |
| `.env.example` | gitignored `.env` in a project (Aider / CLI) |
| `AGENTS.md` | root of **the project you are coding**, so OpenCode/Cursor read the guardrails |

From this repo:

```bash
bash scripts/apply-studio-configs.sh
```

That copies missing files only. It never writes API keys. OpenRouter: create a key at [openrouter.ai/keys](https://openrouter.ai/keys), put it in `~/.continue/.env` **and** `export OPENROUTER_API_KEY=…` in your shell for CLI tools.

Edit the Ollama `model:` lines to match `ollama list` (the installer already chose a RAM tier).

Docs: [OPENCODE.md](../docs/OPENCODE.md) · [OPENROUTER.md](../docs/OPENROUTER.md) · [GUARDRAILS.md](../docs/GUARDRAILS.md)
