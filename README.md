# HessianLLM ML Base Image

A robust, production-ready Docker image for ML/LLM workloads.

## Quick Start

```bash
docker pull ctctctct/hessian-ml-base:latest
```

## What's Included

| Component | Version | Notes |
|-----------|---------|-------|
| Python | 3.11 | Stable, fast, supported until 2027 |
| PyTorch | 2.5.1 | Latest stable release |
| CUDA | 12.4 | Well-tested, broad compatibility |
| cuDNN | 9 | Latest |
| Flash Attention | 2.7.3 | Pre-built wheel (no compilation needed) |

### System Tools
- `tmux`, `screen` - Terminal multiplexers
- `htop`, `nvtop`, `iotop` - System monitoring
- `vim`, `nano` - Editors
- `git`, `git-lfs` - Version control

### ML/LLM Stack
- **HuggingFace**: transformers, accelerate, datasets, tokenizers, peft, trl
- **Training**: deepspeed, bitsandbytes
- **Evaluation**: evaluate, lm-eval
- **Logging**: wandb, tensorboard
- **Data**: pandas, pyarrow, scipy, scikit-learn

## Usage

### Docker Run
```bash
docker run -it --gpus all ctctctct/hessian-ml-base:latest
```

### Determined AI
```yaml
environment:
  image: ctctctct/hessian-ml-base:latest
```

### Docker Compose
```yaml
services:
  ml:
    image: ctctctct/hessian-ml-base:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```

## Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent build from main branch |
| `py311-pt251-cu124` | Explicit version tag |
| `YYYYMMDD` | Date-based tags |
| `<sha>` | Git commit SHA |

## tmux Quick Reference

The image includes a pre-configured tmux with mouse support:

| Command | Action |
|---------|--------|
| `tmux` | Start new session |
| `tmux attach` | Attach to existing session |
| `Ctrl+b \|` | Split pane horizontally |
| `Ctrl+b -` | Split pane vertically |
| `Ctrl+b d` | Detach from session |

## Building Locally

```bash
git clone https://github.com/YOUR_ORG/hessian-ml-base.git
cd hessian-ml-base
docker build -t ctctctct/hessian-ml-base:latest .
```

## License

MIT
