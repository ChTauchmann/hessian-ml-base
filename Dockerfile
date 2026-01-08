# Robust ML Base Image for HessianLLM
# Python 3.11 + PyTorch 2.5.1 + CUDA 12.4 + Flash Attention
#
# Build: docker build -t ctctctct/hessian-ml-base:latest .
# Push:  docker push ctctctct/hessian-ml-base:latest

FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel

LABEL maintainer="HessianLLM"
LABEL description="Robust ML base image with PyTorch 2.5.1, CUDA 12.4, Flash Attention, and common ML tools"

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

# System utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Terminal multiplexers
    tmux \
    screen \
    # Monitoring
    htop \
    nvtop \
    iotop \
    # Editors
    vim \
    nano \
    # Utils
    git \
    git-lfs \
    curl \
    wget \
    tree \
    jq \
    rsync \
    unzip \
    zip \
    # Build tools (for packages that need compilation)
    build-essential \
    ninja-build \
    # Networking (openssh-server required for Determined AI shells)
    openssh-client \
    openssh-server \
    netcat \
    && rm -rf /var/lib/apt/lists/* \
    && git lfs install \
    && mkdir -p /var/run/sshd

# Flash Attention 2 - Pre-built wheel for PyTorch 2.5 + CUDA 12.4 + Python 3.11
# Using pre-built wheel to avoid 30+ min compilation
RUN pip install --no-cache-dir \
    https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.3/flash_attn-2.7.3+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl

# Core ML/LLM Stack
RUN pip install --no-cache-dir \
    # HuggingFace ecosystem
    transformers>=4.47.0 \
    accelerate>=1.2.0 \
    datasets>=3.2.0 \
    tokenizers>=0.21.0 \
    huggingface-hub>=0.27.0 \
    safetensors>=0.4.0 \
    # Training utilities
    peft>=0.14.0 \
    trl>=0.13.0 \
    # Quantization
    bitsandbytes>=0.45.0 \
    # Distributed training
    deepspeed>=0.16.0 \
    # Evaluation
    evaluate>=0.4.0 \
    lm-eval>=0.4.0 \
    # Logging & Experiment tracking
    wandb \
    tensorboard \
    # Data processing
    sentencepiece \
    protobuf \
    scipy \
    scikit-learn \
    pandas \
    pyarrow \
    # Utilities
    tqdm \
    rich \
    python-dotenv \
    pyyaml \
    omegaconf \
    typer \
    httpx

# Optional: vLLM for fast inference (uncomment if needed - adds ~2GB)
# RUN pip install --no-cache-dir vllm>=0.6.0

# tmux configuration with mouse support and better defaults
RUN echo 'set -g mouse on\n\
set -g history-limit 50000\n\
set -g default-terminal "screen-256color"\n\
set -g status-bg colour235\n\
set -g status-fg white\n\
set -g status-left-length 40\n\
set -g status-right "%H:%M %d-%b-%y"\n\
bind | split-window -h\n\
bind - split-window -v\n\
' > /etc/tmux.conf

# Set up a nice bash prompt
RUN echo 'export PS1="\[\033[1;32m\][\u@hessian-ml]\[\033[0m\] \[\033[1;34m\]\w\[\033[0m\] $ "' >> /etc/bash.bashrc

# Create workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import torch; print(f'PyTorch {torch.__version__}, CUDA available: {torch.cuda.is_available()}')" || exit 1

# Default command
CMD ["/bin/bash"]
