FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        xvfb \
        x11vnc \
        novnc \
        websockify \
        openbox \
        xterm \
        dbus-x11 \
        ca-certificates \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/vscode /tmp/vnc \
    && chown -R vscode:vscode /home/vscode /tmp/vnc

USER vscode
WORKDIR /home/vscode

ENV PATH="/home/vscode/.local/bin:/home/vscode/.grok/bin:${PATH}"

# uv (Python). Node 22 は devcontainer feature 側で入る。
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && echo 'export PATH="$HOME/.local/bin:$HOME/.grok/bin:$PATH"' >> /home/vscode/.bashrc

# Grok Build CLI. Auth is not baked in; login or XAI_API_KEY at runtime.
RUN curl -fsSL https://x.ai/cli/install.sh | bash
