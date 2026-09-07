# What’s in this repository

A map of the **actual** tree. Older drafts talked about files that were never added (`INSTALLATION.md`, `ARCHITECTURE.md`, CI workflows). Those names are not missing features — the work lives in the files below.

Landing page: [README.md](README.md).

```
offline-ai-coding/
├── README.md                 Landing page (TH/EN, diagrams, verify)
├── QUICKSTART.md             First session
├── SECURITY.md               Privacy, localhost, licences, no keys
├── LICENSE                   MIT (scripts + docs only)
├── CITATION.cff              Citation + SPDX MIT metadata
├── CONTRIBUTING.md
├── OFF-THE-GRID-GUIDE.md     Mac-oriented narrative
├── TROUBLESHOOTING.md
├── install.sh                Canonical installer
├── scripts/
│   ├── verify.sh             What success looks like (scripted)
│   ├── selftest.sh           Live model pings
│   └── fix-path.sh
├── docs/
│   ├── hero-banner.png
│   ├── diagram-install-flow.png
│   ├── diagram-local-stack.png
│   ├── diagram-localhost-vs-network.png
│   └── HARDWARE.md
└── .github/ISSUE_TEMPLATE/
```

Helpers (`setup-offline-coding.sh`, `install-main.sh`, `start-coding.sh`, `fix-continue-config.sh`, `aider-launcher.sh`, `install-autostart.sh`) are older or optional. **Start with `install.sh`.**

Pointer files (not a second product): [REPO_README.md](REPO_README.md), [QUICKSTART_REPO.md](QUICKSTART_REPO.md), [TROUBLESHOOTING_REPO.md](TROUBLESHOOTING_REPO.md).
