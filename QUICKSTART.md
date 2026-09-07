# Quick start — stranger to local chat

**ไทย:** คำสั่งเดียว รอโมเดลโหลด เปิดเทอร์มินัลใหม่ ตรวจด้วยตารางด้านล่าง แล้วแชทใน VS Code  
**EN:** One command, wait for models, new terminal, verify, then chat.

Canonical landing page: [README.md](README.md). Privacy rules: [SECURITY.md](SECURITY.md). If something fails: [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

---

## 1. Install (network this once)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Nonarkara/offline-ai-coding/main/install.sh)
```

Or:

```bash
git clone https://github.com/Nonarkara/offline-ai-coding.git
cd offline-ai-coding
chmod +x install.sh
./install.sh
```

The script **detects** OS / RAM / disk, **installs** Ollama and RAM-sized models, **wires** Continue + Aider, then runs a short **verify**. Answer the optional WebUI / voice prompts. Downloads dominate the wait (often 20–40 minutes). Safe to re-run; present models are skipped.

Use **`install.sh`**, not the older helper scripts in the tree.

Close Terminal completely and open a **new** one so `PATH` and `aider-offline` load.

---

## 2. What success looks like

Run these on the machine you just installed. You do not need the internet for this table.

| # | Check | Command / action | Pass |
|---|--------|------------------|------|
| 1 | Models on disk | `ollama list` | Chat + complete + reason IDs for [your RAM tier](README.md#hardware-tiers) (8 GB includes `gemma4:e4b`) |
| 2 | Loopback API | `curl -sf http://localhost:11434/api/tags` | JSON, not a connection error |
| 3 | Continue is local | `grep -E 'apiBase|allowAnonymousTelemetry' ~/.continue/config.json` | `http://localhost:11434` and `false` |
| 4 | Scripted verify | From this repo: `bash scripts/verify.sh` | Core tools + models + config pass |
| 5 | Editor chat | VS Code → **Cmd+L** / **Ctrl+L** → `Reply with: I am working locally.` | A short reply, no vendor login |
| 6 | Tab complete | Type a function, press Tab | A local suggestion |
| 7 | Terminal agent (optional) | `cd` into a **git** repo → `aider-offline` | Aider starts on the local chat model |

Optional deeper ping (actually calls the models): `bash scripts/selftest.sh`.

If a row fails, do **not** paste an API key. Open [TROUBLESHOOTING.md](TROUBLESHOOTING.md) — start with PATH and `ollama serve`.

---

## 3. First five minutes

### VS Code (usual path)

1. Open Visual Studio Code.
2. File → Open Folder → any project you own.
3. Press **Cmd+L** (Mac) or **Ctrl+L** (Linux / Windows).
4. Ask in plain language, then **read the diff** before you accept.

Examples you can try on a scratch file:

- “Add a function that returns the sum of a list.”
- “Explain this file in three bullets.”
- “Write a test for the function I just added.”

Tab accepts autocomplete as you type.

### Aider (terminal agent)

```bash
cd ~/your-project   # must be a git repo
aider-offline
```

Aider can edit several files and commit. Review every commit. This is still a model.

### Optional browser chat

```bash
webui-start
```

Then open `http://localhost:8080` — not a public URL.

---

## Hardware (short)

| Your RAM | Chat model the installer picks |
|----------|--------------------------------|
| 64 GB+ | `qwen2.5-coder:32b` |
| 32 GB | `qwen2.5-coder:32b` |
| 16 GB | `qwen2.5-coder:14b` |
| 8 GB | `gemma4:e4b` (needs Ollama 0.22+) |
| under 8 GB | installer exits |

Full table and machine notes: [docs/HARDWARE.md](docs/HARDWARE.md).

---

## Safety in one screen

- After setup, traffic should be **localhost**. Pointing Continue at a cloud API is not this method.
- Continue telemetry is **off** in the file the installer writes.
- [LICENSE](LICENSE) is MIT for **scripts and docs**. Model weights have their own licences.
- Never commit `~/.continue/`, `~/.ollama/`, `.env`, or keys. See [SECURITY.md](SECURITY.md).
- Review generated code. Local does not mean correct.

---

## If it breaks

| Symptom | Jump |
|---------|------|
| `command not found` | [TROUBLESHOOTING.md](TROUBLESHOOTING.md#command-not-found-for-basic-commands) |
| `ollama` missing | [TROUBLESHOOTING.md](TROUBLESHOOTING.md#command-not-found-ollama) |
| Continue empty / no model | [TROUBLESHOOTING.md](TROUBLESHOOTING.md#vscode-no-model-configured-in-continuedev-chat) |
| Install interrupted | Re-run `install.sh` |
| Machine too small | [docs/HARDWARE.md](docs/HARDWARE.md) |

Diagrams of the flow, the stack, and localhost vs network: [README.md#diagrams](README.md#diagrams).
