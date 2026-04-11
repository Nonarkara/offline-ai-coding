# Contributing

We want this to work on every platform, for every developer, regardless of technical skill.

## How to Help

### Report Bugs
1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) first
2. Search existing [Issues](https://github.com/nonarkara/offline-ai-coding/issues)
3. Open a new issue with:
   - What you were doing
   - Exact error message (copy-paste, not screenshot)
   - Your hardware: RAM, CPU, OS version
   - Output of `ollama list` and `echo $PATH`

### Suggest Features
Open a [Discussion](https://github.com/nonarkara/offline-ai-coding/discussions). Describe the feature and why it helps offline developers.

### Submit Code
1. Fork the repo
2. Create a branch: `git checkout -b feature/your-feature`
3. Make changes and test on your machine
4. Submit a PR with: what you changed, why, and how to test it

## Areas We Need Help

| Area | Priority | Description |
|------|----------|-------------|
| **Linux support** | High | Full testing on Ubuntu, Fedora, Arch, etc. |
| **Windows WSL2** | High | Getting seamless Windows support |
| **GPU acceleration** | Medium | NVIDIA CUDA, AMD ROCm integration |
| **Documentation** | Medium | Video walkthroughs, translations, guides |
| **Model benchmarks** | Medium | Testing new models as they're released |
| **CI/CD** | Low | Automated installer testing |

## Code Guidelines

- Shell scripts: bash, POSIX-compatible where possible
- Documentation: Markdown, conversational tone, explain like the reader is new
- Test before submitting
- Comment your code — someone who's never seen it should understand it

## Philosophy

This project is free, open, and community-driven. By contributing, you agree your code will be MIT-licensed. No CLAs. No corporate red tape.

We believe in sharing knowledge freely. Your contribution helps developers worldwide save money and gain independence.

Thank you.
