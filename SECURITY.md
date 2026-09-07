# Privacy and safety

This repo is a **local** installer. The method is public; keys stay on your machine. If a step only works by pasting a secret into git, the step is wrong.

Landing page: [README.md](README.md). First session: [QUICKSTART.md](QUICKSTART.md).

---

## What “offline” means here

| Phase | Network | What moves |
|-------|---------|------------|
| **First install** | Required | Homebrew (or equivalent), Ollama, model weights (`ollama pull`), VS Code / Continue if missing, optional pip packages |
| **After verify** | Not required | Chat, tab complete, Aider, optional WebUI, optional Pocket TTS — all to `127.0.0.1` |
| **Later, when you choose** | Optional | `git push`, `brew upgrade`, new `ollama pull` |

Internet once is not “offline forever from minute zero.” After models live under `~/.ollama`, you can disconnect and keep coding.

**Do not call the cloud “offline.”** Wiring Continue, Aider, or any editor to a hosted API (OpenAI, Anthropic, OpenRouter, Copilot, …) is a different product. If you do that, label it online. Do not advertise it as this stack.

---

## Localhost and telemetry

The installer writes `~/.continue/config.json` with:

- `apiBase`: `http://localhost:11434`
- `allowAnonymousTelemetry`: `false`

Confirm after install:

```bash
grep -E 'apiBase|allowAnonymousTelemetry' ~/.continue/config.json
curl -sf http://localhost:11434/api/tags
bash scripts/verify.sh
```

Optional Open WebUI is `http://localhost:8080` on **your** loopback, not a studio URL. Do not bind it to a public interface and call that “the official demo.”

---

## Secrets — never in this tree

Do not commit:

- API keys, tokens, `.env`, `auth.json`, PEM / SSH keys
- A real `~/.continue/` or `~/.ollama/` directory
- Someone else’s Aider config, session logs, or pairing codes

`.gitignore` already covers the common patterns. Do not use `git add -f` to override them.

Placeholders in docs stay placeholders (`your-project`, `localhost`, public model IDs).

---

## Licences (honesty)

| Thing | Licence you actually get |
|-------|--------------------------|
| Scripts and docs in **this** repo | [MIT](LICENSE) — Copyright © 2026 Non Arkaraprasertkul / Axiom X Co., Ltd. |
| Ollama, VS Code, Continue.dev, Aider, Open WebUI, Pocket TTS | Each project’s own terms |
| Qwen, Gemma, DeepSeek, and anything you `ollama pull` | Each **model’s** licence — not relicensed by our MIT file |

Read the model card before commercial use. “The installer is MIT” does not mean “the weights are MIT.”

---

## Review generated code

A model on your disk can still invent APIs, leak patterns from training data, or write insecure code. Treat output as a junior draft:

- Read the diff.
- Run tests you trust.
- Do not paste secrets **into** the prompt either — the model does not need your production key to sketch a handler.

---

## What this repo will not do

- Ship a hosted coding assistant or a live product URL.
- Rank models behind a closed score.
- Imply this is Claude, Copilot, Cursor, or an official depa / municipal / UN tool.
- Ask you to paste a vendor key to finish setup.

Related hardening for a *gateway* (channels, exec policy) lives in [dr-non-openclaw-setup](https://github.com/Nonarkara/dr-non-openclaw-setup) — a different job. This repo is editor + terminal + local Ollama.

---

## If you fork

Say so. Keep telemetry off unless the operator opts in. Keep model-licence notes. Do not publish a restyled installer as the official Nonarkara stack.
