# Troubleshooting — We've Hit All These Problems. Solutions Included.

This guide covers the issues we've encountered in hundreds of installations. **Read this if anything isn't working.**

---

## "Command not found" for Basic Commands

**Symptom:** When you type `mkdir`, `ls`, `cat`, etc., you get "command not found"

**Root cause:** Your shell's PATH environment variable is broken. This breaks *everything*.

**Fix (Quick):**
```bash
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
```

Hit Enter. Try `ls` again. If it works, the PATH is fixed for this session.

**Fix (Permanent):**
```bash
echo 'export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"' >> ~/.zprofile
```

Close Terminal completely (Cmd+Q), reopen it, and test `ls`. Now it's permanent.

---

## "command not found: ollama"

**Symptom:** When you type `ollama list` or any ollama command, it says "command not found"

**Root cause:** Ollama isn't in your PATH, or didn't install properly

**Quick fix (this session):**
```bash
/opt/homebrew/bin/ollama list
```

If that works, Ollama is installed but not in PATH. See "Command not found for basic commands" above.

**Full fix (if Ollama isn't installed):**
```bash
brew install ollama
brew services start ollama
```

Then test:
```bash
ollama list
```

Should show your downloaded models.

---

## "listen tcp 127.0.0.1:11434: bind: address already in use"

**Symptom:** When you try to run `ollama serve`, you get this error

**Root cause:** Ollama is already running. This is actually fine — it means the AI engine is active.

**What to do:** Just close that Terminal tab and continue. Ollama is working. Check if it's in your menu bar (llama icon, top right of Mac screen).

If you want to see what Ollama is doing:
```bash
ollama list
```

This shows your models. If they're there, everything is working.

---

## VS Code: "No model configured" in Continue.dev Chat

**Symptom:** VS Code's Continue.dev sidebar says "No models configured" even after setup

**Root cause:** Continue.dev can't find the config file, or needs to be restarted

**Quick fix:**
1. **Quit VS Code completely:** Cmd+Q
2. **Reopen VS Code**
3. **Make sure Ollama is running:**
   ```bash
   /opt/homebrew/bin/ollama list
   ```
   Should show models. If not, run `ollama serve` in another Terminal tab.
4. **Press Cmd+L** in VS Code

If it still doesn't work, the config file didn't write properly.

**Rebuild the config:**
```bash
mkdir -p ~/.continue
cat > ~/.continue/config.json << 'EOF'
{
  "models": [
    {
      "title": "Qwen Coder (Offline)",
      "provider": "ollama",
      "model": "qwen2.5-coder:32b",
      "apiBase": "http://localhost:11434",
      "contextLength": 32768,
      "completionOptions": {"temperature": 0.1, "maxTokens": 4096},
      "capabilities": {"tools": false}
    }
  ],
  "tabAutocompleteModel": {
    "title": "Qwen Coder (Autocomplete)",
    "provider": "ollama",
    "model": "qwen2.5-coder:7b",
    "apiBase": "http://localhost:11434"
  },
  "allowAnonymousTelemetry": false
}
EOF
```

Then restart VS Code (Cmd+Q, reopen).

---

## "Model not found" when asking AI a question

**Symptom:** You press Cmd+L, type a message, hit Enter, and get "model not found"

**Root cause:** The model list is empty, or Ollama isn't running

**Check if Ollama is running:**
```bash
pgrep -x ollama
```

If it returns a number, Ollama is running. If nothing, run:
```bash
ollama serve
```

**Check if models exist:**
```bash
ollama list
```

Should show something like:
```
NAME                  ID              SIZE    MODIFIED
qwen2.5-coder:32b     b92d6a0bd47e    19 GB   2 hours ago
qwen2.5-coder:7b      dae161e27b0e    4.7 GB  1 hour ago
```

If the list is empty, the download didn't complete. Re-run the installer:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Nonarkara/offline-ai-coding/main/install.sh)
```

It will resume downloading models.

---

## VS Code Chat Returns Raw JSON Instead of Text

**Symptom:** When you ask the AI a question, it responds with JSON like:
```
{"name": "read_currently_open_file", "arguments": {}}
```

Instead of normal English text.

**Root cause:** The model is trying to use tool calling but the response isn't being parsed correctly

**Fix:**
1. Make sure Ollama is running
2. Restart VS Code (Cmd+Q, reopen)
3. If it persists, rebuild the Continue config (see "No model configured" above, make sure `"tools": false` in the config)

---

## Installation Script Fails / Interrupts

**Symptom:** The installer crashes or gets interrupted

**What to do:**
1. **Close the Terminal**
2. **Open a new Terminal**
3. **Run the installer again:**
   ```bash
   bash <(curl -fsSL https://raw.githubusercontent.com/Nonarkara/offline-ai-coding/main/install.sh)
   ```

The script is idempotent — it checks what's already installed and skips it. It's safe to re-run.

**If model download interrupts:**
The script will resume from where it left off. Model downloads are resumable. Just re-run the installer.

---

## Model Download Stuck / Very Slow

**Symptom:** The installer has been downloading a model for hours with no progress

**Why:** Large models (19-30GB) take time, especially on slow internet

**What's normal:**
- 100 Mbps connection: ~25 minutes per 10GB
- 50 Mbps connection: ~50 minutes per 10GB
- 10 Mbps connection: ~4 hours per 10GB

**If it's stuck (no activity for 10+ minutes):**
1. **Stop it:** Ctrl+C
2. **Open new Terminal tab and check Ollama:**
   ```bash
   ollama list
   ```
   Partially downloaded models show up here.
3. **Re-run the installer:**
   ```bash
   bash <(curl -fsSL https://raw.githubusercontent.com/Nonarkara/offline-ai-coding/main/install.sh)
   ```
   It will resume the download.

**To save data:** If you're low on disk space, you can delete partially downloaded models and re-download smaller ones:
```bash
ollama rm qwen2.5-coder:32b  # deletes it
ollama pull qwen2.5-coder:7b  # downloads smaller version
```

---

## "Homebrew: command not found"

**Symptom:** When you type `brew`, it says "command not found"

**Root cause:** Homebrew didn't install, or PATH is broken

**Fix Homebrew:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Fix PATH (see "Command not found" section above)**

---

## Aider Doesn't Work / "aider-offline: command not found"

**Symptom:** When you type `aider-offline`, it says "command not found"

**Root cause:** Aider didn't install, or the alias wasn't created

**Fix:**
```bash
python3 -m pip install aider-chat --break-system-packages
```

Then add the alias:
```bash
echo "alias aider-offline='aider --model ollama_chat/qwen2.5-coder:32b'" >> ~/.zshrc
```

Close Terminal (Cmd+Q), reopen, and try `aider-offline` again.

---

## "Rosetta installation required"

**Symptom:** When launching something, macOS says you need to install Rosetta

**What to do:** Click "Install". Rosetta is Apple's legitimate tool that lets Intel-based software run on Apple Silicon Macs. It's safe, official, and necessary.

After installation, restart the app that prompted you.

---

## Models Downloaded but Very Slow

**Symptom:** The AI responds, but very slowly (30+ seconds per response)

**Why:** Could be several reasons depending on your hardware

**Check RAM:**
```bash
sysctl -n hw.memsize | awk '{print $1 / 1073741824 " GB"}'
```

If you have 16GB RAM but installed 32B model, that's the issue. The model is swapping to disk.

**Solution:**
```bash
ollama rm qwen2.5-coder:32b        # delete the large model
ollama pull qwen2.5-coder:14b      # pull the smaller one
```

Then update the Continue config to use `qwen2.5-coder:14b` instead.

**Check if other processes are using RAM:**
```bash
top
```

(Press Q to exit)

If you see other apps using lots of memory, close them while coding.

---

## Can't Open GitHub Repo (Offline)

**Symptom:** You want to clone a repo but have no internet

**Solution:** Clone it when you have internet:
```bash
git clone https://github.com/yourusername/my-repo.git ~/my-repo
```

Then later, offline:
```bash
cd ~/my-repo
aider-offline
```

Git works offline for local commits. You just can't push/pull from GitHub until you reconnect.

---

## Continue.dev Shows Extension Errors

**Symptom:** Red error messages in the Continue sidebar

**Common error:** "Failed to connect to Ollama"

**Fix:**
1. Check Ollama is running: `ollama list` should work
2. Restart VS Code: Cmd+Q, reopen
3. If persists, check if Ollama crashed: `ollama serve` (should start without errors)

---

## Linux: "bash: /opt/homebrew/bin/ollama: No such file"

**Symptom:** You're on Linux and getting this error

**Root cause:** Homebrew installs to different path on Linux

**Fix:**
```bash
which ollama
```

This shows where ollama actually is. Use that path.

Or just use:
```bash
ollama list
```

If it works, PATH is already fixed.

---

## Windows/WSL: Things Don't Work

**Symptom:** Various issues on Windows or WSL2

**Note:** We recommend macOS or native Linux for best experience. Windows WSL2 support is in progress.

**Workaround:**
1. Make sure you're using WSL2 (not WSL1):
   ```bash
   wsl --list --verbose
   ```
   Should show VERSION 2.
2. Install WSL2:
   ```powershell
   wsl --install
   ```
3. Then run the installer script inside WSL2.

**Report bugs** on the GitHub repo. WSL support is actively being improved.

---

## My Computer Is Too Old/Slow

**Symptom:** The installer says your hardware can't run this

**Check specs:**
```bash
# RAM
sysctl -n hw.memsize | awk '{print $1 / 1073741824 " GB"}'

# CPU cores
sysctl -n hw.ncpu
```

**Minimum:** 8GB RAM, any CPU made in the last 10 years.

**Reality:** Even on 8GB with a 10-year-old CPU, it works. It's just slower. You might wait 30-40 seconds for a response instead of 10.

**If you're at the minimum:** Use the 7B models instead of 32B. They're faster and still surprisingly good.

```bash
# in ~/.continue/config.json, change:
# "model": "qwen2.5-coder:32b"
# to:
# "model": "qwen2.5-coder:7b"
```

---

## OpenCode: no Ollama models in `/models`

**Cause:** OpenCode does not auto-list Ollama tags. They must be in `~/.config/opencode/opencode.jsonc` under `provider.ollama.models` with the **exact** name from `ollama list`.

**Fix:** `bash scripts/apply-studio-configs.sh` from a clone, then edit `"model": "ollama/<your-tag>"`. Base URL must end in `/v1`. See [docs/OPENCODE.md](docs/OPENCODE.md).

---

## OpenCode / Continue: replies truncate or the agent “forgets” the repo

**Cause:** Ollama’s daemon default context is 4096. Client `contextLength` does not override it.

**Fix:**

```bash
launchctl getenv OLLAMA_CONTEXT_LENGTH
launchctl setenv OLLAMA_CONTEXT_LENGTH 16384
```

Fully quit Ollama.app and reopen. If you then see “model requires more system memory”, lower the number (8GB machines: 8192 or 2048).

---

## Continue: OpenRouter models missing or “no API key”

**Cause:** VS Code does not read `export OPENROUTER_API_KEY` from Terminal. YAML also **replaces** JSON if `~/.continue/config.yaml` exists.

**Fix:** Put `OPENROUTER_API_KEY=` in `~/.continue/.env` (no quotes needed). Restart VS Code. Template: `examples/continue.config.yaml`.

---

## OpenRouter: 429 Too Many Requests

**Cause:** Free-tier cap (published as 50/day until credits, 20/min). Failed calls still count. Popular `:free` slugs are globally busy.

**Fix:** Switch the Continue/OpenCode/Aider model back to **local Ollama**. Wait. Do not put the key in git or rotate keys to dodge the cap. Confirm current slugs at https://openrouter.ai/models?q=free

---

## `aider-openrouter`: command not found / 401

New terminal after install. `echo $OPENROUTER_API_KEY` must be non-empty for CLI (unlike Continue). Alias is `aider --model openrouter/cohere/north-mini-code:free`. List: `aider --list-models openrouter/`.

---

## Something Else Broke

**Not listed here?** Open an issue on GitHub:
https://github.com/Nonarkara/offline-ai-coding/issues

Include:
1. What you were trying to do
2. The exact error message
3. Your hardware (output of `sysctl -n hw.memsize` on Mac, or `free -h` on Linux)
4. Your OS (macOS version, Linux distro, etc.)

We'll help fix it, and add it to this guide so others don't hit it.

---

## Getting Help

1. **Check this file first** — most issues are covered
2. **Check [README.md](README.md)** for the big picture
3. **Open an issue** on GitHub with details
4. **Or:** Detailed discussion in the Discussions tab

We built this because we were frustrated with complex setups. If it's still complex for you, that's a bug we want to fix.

**You're not alone. We've hit all these problems. They have solutions.**
