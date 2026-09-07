# Contributing

We want this to work on every platform, for every developer, regardless of technical skill. The method is public; **keys stay out of git**.

Read [SECURITY.md](SECURITY.md) before you open a PR.

## How to help

### Report bugs

1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) first
2. Search existing [Issues](https://github.com/Nonarkara/offline-ai-coding/issues)
3. Open a new issue with:
   - What you were doing
   - Exact error message (copy-paste, not a screenshot of a secret)
   - Hardware: RAM, CPU, OS version
   - Output of `ollama list` and `echo $PATH`

Do not paste API keys, `.env` files, or a full `~/.continue/config.json` if you added a cloud provider.

### Suggest features

Open a [Discussion](https://github.com/Nonarkara/offline-ai-coding/discussions). Describe the feature and why it helps **offline** developers. Do not propose “just add OpenAI” as the default path.

### Submit code

1. Fork the repo
2. Create a branch: `git checkout -b feature/your-feature`
3. Make changes and test on your machine (`bash scripts/verify.sh` if you touch the installer)
4. Submit a PR with: what you changed, why, and how to test it

## Areas we need help

| Area | Priority | Description |
|------|----------|-------------|
| **Linux support** | High | Full testing on Ubuntu, Fedora, Arch, etc. |
| **Windows WSL2** | High | Getting seamless Windows support |
| **GPU acceleration** | Medium | NVIDIA CUDA, AMD ROCm notes that do not invent scores |
| **Documentation** | Medium | Translations (ไทย / EN), clearer verify steps |
| **Model cards** | Medium | Licence links and RAM fit for new public IDs |
| **CI/CD** | Low | Automated installer testing without secrets |

## Code guidelines

- Shell scripts: bash, POSIX-compatible where possible
- Documentation: Markdown, bilingual welcome where it helps, explain like the reader is new
- Test before submitting
- Comment your code — someone who has never seen it should understand it
- No secrets, no private Continue/Ollama dumps, no “cloud but we call it offline”

## Philosophy

This project is free, open, and community-driven. By contributing, you agree your code will be MIT-licensed (same as [LICENSE](LICENSE)). No CLAs.

MIT covers **this repository**. It does not relicense model weights.

Thank you.
