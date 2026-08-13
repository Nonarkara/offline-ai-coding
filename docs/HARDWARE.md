# Hardware Compatibility Guide

## Quick Answer

**Got 32GB+ RAM and an Apple Silicon Mac?** You'll have the best experience. Near GPT-4o quality.

**Got 16GB RAM?** Great experience. Slightly smaller models but still very good.

**Got 8GB RAM?** It works. Slower responses but functional. Worth trying.

**Less than 8GB?** Unfortunately too limited for local LLMs.

---

## Detailed Compatibility

### Apple Silicon Mac (M1, M2, M3, M4)

**Why it's the best:** Apple's unified memory architecture means the GPU and CPU share RAM. LLMs can use all your memory, not just the GPU's VRAM. This is a massive advantage.

| Chip | RAM | Models | Speed | Quality |
|------|-----|--------|-------|---------|
| M1 | 8GB | Gemma 4 E4B | ~25 tok/s | Good — better than Qwen 7B at the same footprint (~4.5B active params) |
| M1 | 16GB | Qwen 14B | ~15 tok/s | Very good |
| M1 Pro/Max | 32GB | Qwen 32B | ~8 tok/s | Excellent |
| M2 | 8GB | Gemma 4 E4B | ~30 tok/s | Good |
| M2 | 16GB | Qwen 14B | ~18 tok/s | Very good |
| M2 Pro/Max | 32GB | Qwen 32B | ~10 tok/s | Excellent |
| M3 | 16GB | Qwen 14B | ~20 tok/s | Very good |
| M3 Pro/Max | 32-64GB | Qwen 32B | ~12 tok/s | Excellent |
| M4 | 16-32GB | Qwen 32B | ~15 tok/s | Excellent |

### Intel Mac

Works via Rosetta 2 translation. Slightly slower than Apple Silicon.

| RAM | Models | Speed | Quality |
|-----|--------|-------|---------|
| 8GB | Gemma 4 E4B | ~15 tok/s | Good |
| 16GB | Qwen 14B | ~10 tok/s | Very good |
| 32GB+ | Qwen 32B | ~6 tok/s | Excellent |

### Linux (CPU Only)

| RAM | Models | Speed | Notes |
|-----|--------|-------|-------|
| 8GB | Gemma 4 E4B | ~15 tok/s | Functional |
| 16GB | Qwen 14B | ~12 tok/s | Good |
| 32GB+ | Qwen 32B | ~8 tok/s | Great |

### Linux with NVIDIA GPU

GPU acceleration significantly improves speed:

| GPU | VRAM | Models | Speed |
|-----|------|--------|-------|
| RTX 3060 | 12GB | Qwen 7B | ~40 tok/s |
| RTX 3080 | 10GB | Qwen 7B | ~50 tok/s |
| RTX 4090 | 24GB | Qwen 14B | ~35 tok/s |
| A100 | 80GB | Qwen 32B | ~60 tok/s |

*Note: GPU support is being improved. Some models may need manual configuration.*

### Windows (WSL2)

Requires Windows Subsystem for Linux 2. Performance similar to Linux.

---

## Disk Space Requirements

| Setup | Total Disk Needed |
|-------|------------------|
| 8GB RAM tier | ~15GB |
| 16GB RAM tier | ~20GB |
| 32GB RAM tier | ~35GB |
| 64GB RAM tier | ~40GB |

Plus ~5GB for Ollama, VS Code, and tools.

**Recommendation:** Have at least 50GB free before installing.

### Voice (optional, any tier)

Kyutai Pocket TTS is 100M parameters — under 1GB on disk, real-time on CPU alone.
It doesn't need its own RAM tier; if you can run the 8GB chat model, you can run
this alongside it. No GPU, no extra download budget to plan for.

---

## How to Check Your Specs

### macOS
```bash
# RAM
sysctl -n hw.memsize | awk '{printf "%.0f GB\n", $1/1073741824}'

# CPU
sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Apple Silicon"

# Free disk
df -h ~ | tail -1 | awk '{print $4 " free"}'
```

### Linux
```bash
# RAM
free -h | grep Mem | awk '{print $2}'

# CPU
lscpu | grep "Model name"

# Free disk
df -h ~ | tail -1 | awk '{print $4 " free"}'

# GPU (if NVIDIA)
nvidia-smi 2>/dev/null || echo "No NVIDIA GPU detected"
```

---

## Upgrading Your Hardware

If you're considering a hardware upgrade specifically for offline AI coding:

**Best value:** MacBook Air M3 with 24GB RAM (~$1,499). Runs Qwen 14B beautifully.

**Best performance:** MacBook Pro M3 Max with 64GB RAM (~$3,499). Runs everything at full speed.

**Best budget:** Any used M1 Mac with 16GB RAM (~$600-800 used). Still excellent for Qwen 14B.

**Linux alternative:** Any desktop with 32GB RAM and an RTX 3060+ (~$800-1200 custom build).

Compare to: $20/month × 12 months = $240/year for a single AI subscription. The hardware pays for itself.
