# OpenRouter — free models in VS Code and CLI

Use this when you **have a network** and want free (rate-limited) cloud models next to the local Ollama stack. It does **not** make the machine offline. After the first local install you can ignore this file forever.

Official: [OpenRouter models](https://openrouter.ai/models) · [free router](https://openrouter.ai/openrouter/free) · [rate limits](https://openrouter.zendesk.com/hc/en-us/articles/39501163636379-OpenRouter-Rate-Limits-What-You-Need-to-Know) · [provider privacy](https://openrouter.ai/docs/guides/routing/provider-selection) · [Continue](https://docs.continue.dev/customize/model-providers/top-level/openrouter) · [Aider](https://aider.chat/docs/llms/openrouter.html) · [OpenCode](https://openrouter.ai/docs/cookbook/coding-agents/opencode-integration)

## Get a key (name only)

1. Sign in at OpenRouter and create a key. It looks like `sk-or-v1-…`.
2. **VS Code / Continue:** put it in `~/.continue/.env` as `OPENROUTER_API_KEY=` — Continue’s IDE **cannot** read `export` from zsh.
3. **Aider / other CLI:** `export OPENROUTER_API_KEY=…` in `~/.zprofile` **or** a **gitignored** project `.env`.
4. **OpenCode:** `/connect` → OpenRouter. Stored in `~/.local/share/opencode/auth.json`.

Never put the value in `config.yaml`, `opencode.json`, `aider.conf.yml`, or this git repo.

## Free tier (honest limits)

From OpenRouter’s published free-tier notes (re-check if you are reading this later):

- **50 requests/day** on free models until the account has purchased credits; then the published bump is **1000/day**.
- **20 requests/minute**.
- **429 Too Many Requests** is normal on popular `:free` slugs. **Failed attempts still count** toward the day cap.
- The **catalog of `:free` models changes**. IDs in this repo are a snapshot. Canonical list: [openrouter.ai/models?q=free](https://openrouter.ai/models?q=free). `aider --list-models openrouter/` lists what Aider knows.

`openrouter/free` is OpenRouter’s **free-model router** (picks a free model that supports the features you asked for). It is not a quality ranking from this studio.

## Privacy

Default routing may include providers that **store or train on prompts**. For private code:

- Account: [Privacy settings](https://openrouter.ai/settings/privacy) — disable providers that train on inputs if you need that.
- Per request: `provider.data_collection = "deny"` (Continue example and Aider `extra_body` example do this).
- Some **`:free` model cards** (e.g. Poolside Laguna, Liquid LFM) say free use **may train** on inputs. Do not send secrets there. The example configs prefer Gemma 4, North Mini Code, and the official free router.

Aider’s docs also note the inverse: if a model **fails** until you enable training-capable providers, that is an OpenRouter account setting — not something this installer flips for you.

Calling OpenRouter “offline AI” is a lie. Use Ollama for air-gapped work.

## VS Code (Continue.dev)

Continue’s current format is **YAML** at `~/.continue/config.yaml`. If that file exists, it **wins over** `~/.continue/config.json` (the installer still writes JSON for older Continue).

Template: [`examples/continue.config.yaml`](../examples/continue.config.yaml)

```yaml
  - name: OpenRouter free router
    provider: openrouter
    model: openrouter/free
    apiBase: https://openrouter.ai/api/v1
    apiKey: ${{ secrets.OPENROUTER_API_KEY }}
    roles: [chat, edit]
```

`${{ secrets.OPENROUTER_API_KEY }}` resolves from `~/.continue/.env` (and project `.continue/.env`). Restart VS Code after creating the env file.

In the Continue sidebar, switch the model dropdown from **Local chat (Ollama)** to an OpenRouter name. Tab autocomplete should stay on the **local** Qwen complete model so you do not burn 50/day on every keystroke.

If Agent / tools misbehave through the proxy, Continue allows `capabilities: [tool_use]` on that model. Not every free slug supports tools.

## CLI (Aider)

Template: [`examples/aider.conf.yml`](../examples/aider.conf.yml)

```bash
export OPENROUTER_API_KEY=   # your key, not in git
cd ~/Projects/my-app
aider --model openrouter/cohere/north-mini-code:free
# or
aider --model openrouter/google/gemma-4-31b-it:free
aider --list-models openrouter/
```

Aider’s OpenRouter ids are `openrouter/<vendor>/<model>`. Default in this repo stays `aider-offline` → local `ollama_chat/<CHAT_MODEL>`.

Optional `~/.aider.model.settings.yml` (from Aider’s OpenRouter page) to deny training-capable providers:

```yaml
- name: openrouter/cohere/north-mini-code:free
  extra_params:
    extra_body:
      provider:
        data_collection: "deny"
        allow_fallbacks: true
```

Keep `auto-commits: false` in the example so the agent does not commit until you say so.

## CLI / TUI (OpenCode)

See [OPENCODE.md](OPENCODE.md). `/connect` once. Then `/models` → `openrouter/…`.

```bash
opencode --model openrouter/cohere/north-mini-code:free
```

## curl smoke test (no secrets in the command history if you use the env var)

```bash
curl -s https://openrouter.ai/api/v1/models | python3 -c \
  'import sys,json; d=json.load(sys.stdin);
print("\n".join(sorted(m["id"] for m in d["data"] if m["id"].endswith(":free") or m["id"]=="openrouter/free")))'
```

Do not paste the API key into the README or a ticket.

## When to use which path

| Situation | Use |
|-----------|-----|
| Plane, bad wifi, private repo | Ollama only |
| M3 Air 16GB struggling with 14B | Stay local with a smaller tag, **or** OpenRouter free for the hard prompt |
| M5 Max 128GB at the desk | Local 32B-class chat; OpenRouter only if you want a different model |
| Need tools/agent loop and local model is weak | OpenCode + a `:free` coding slug, with permissions on **ask** |
| Hit 429 / daily cap | Back to Ollama; wait; do not rotate keys to dodge limits |

## Guardrails

Full list: [GUARDRAILS.md](GUARDRAILS.md). Short version: no keys in git, no autocomplete via paid/free cloud, no calling this path “offline,” review every patch.
