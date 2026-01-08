# HessianLLM Extended Image
# Based on mbrack/forty-two (Determined AI compatible)
# Adds: tmux, htop, and other convenience tools
#
# Build: docker build -t ctctctct/hessian-ml-base:latest .
# Push:  docker push ctctctct/hessian-ml-base:latest

FROM mbrack/forty-two:latest

LABEL maintainer="HessianLLM"
LABEL description="Extended forty-two image with tmux and convenience tools"

# Add tmux and other useful tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    tmux \
    htop \
    nvtop \
    tree \
    && rm -rf /var/lib/apt/lists/*

# tmux configuration with mouse support
RUN echo 'set -g mouse on\n\
set -g history-limit 50000\n\
set -g default-terminal "screen-256color"\n\
bind | split-window -h\n\
bind - split-window -v\n\
' > /etc/tmux.conf

CMD ["/bin/bash"]
