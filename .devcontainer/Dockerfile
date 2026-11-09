FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

USER root

# Runtime is non-root (vscode), so apt cannot run later.
# Install desktop (Xvfb/VNC) plus Playwright OS libs at image build time.
# Browser binaries themselves: npx playwright install (user cache, no root).
# Package names match Playwright install-deps for Ubuntu 24.04 (noble, t64).
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
        wget \
        unzip \
        libasound2t64 \
        libatk-bridge2.0-0t64 \
        libatk1.0-0t64 \
        libatspi2.0-0t64 \
        libatomic1 \
        libavif16 \
        libcairo2 \
        libcairo-gobject2 \
        libcups2t64 \
        libdbus-1-3 \
        libdrm2 \
        libenchant-2-2 \
        libepoxy0 \
        libevent-2.1-7t64 \
        libflite1 \
        libfontconfig1 \
        libfreetype6 \
        libgbm1 \
        libgdk-pixbuf-2.0-0 \
        libgles2 \
        libglib2.0-0t64 \
        libgstreamer1.0-0 \
        libgstreamer-gl1.0-0 \
        libgstreamer-plugins-bad1.0-0 \
        libgstreamer-plugins-base1.0-0 \
        libgtk-3-0t64 \
        libgtk-4-1 \
        libharfbuzz0b \
        libharfbuzz-icu0 \
        libhyphen0 \
        libicu74 \
        libjpeg-turbo8 \
        liblcms2-2 \
        libmanette-0.2-0 \
        libnspr4 \
        libnss3 \
        libopus0 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libpng16-16t64 \
        libsecret-1-0 \
        libvpx9 \
        libwayland-client0 \
        libwayland-egl1 \
        libwayland-server0 \
        libwebp7 \
        libwebpdemux2 \
        libwoff1 \
        libx11-6 \
        libx11-xcb1 \
        libx264-164 \
        libxcb1 \
        libxcb-shm0 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxkbcommon0 \
        libxml2 \
        libxrandr2 \
        libxrender1 \
        libxslt1.1 \
        libxss1 \
        libxshmfence1 \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        fonts-liberation \
        fonts-noto-color-emoji \
        fonts-unifont \
        fonts-ipafont-gothic \
        fonts-wqy-zenhei \
        fonts-tlwg-loma-otf \
        fonts-freefont-ttf \
        xfonts-cyrillic \
        xfonts-scalable \
    && rm -rf /var/lib/apt/lists/*

COPY .devcontainer/start-desktop.sh /usr/local/bin/start-desktop.sh
COPY .devcontainer/docker-entrypoint.sh /usr/local/bin/devcontainer-entrypoint.sh
RUN chmod 755 /usr/local/bin/start-desktop.sh /usr/local/bin/devcontainer-entrypoint.sh \
    && mkdir -p /home/vscode /tmp/vnc \
    && mkdir -p /var/uv-venvs \
    && chown -R vscode:vscode /home/vscode /tmp/vnc /var/uv-venvs

USER vscode
WORKDIR /home/vscode

ENV PATH="/home/vscode/.local/bin:/home/vscode/.grok/bin:${PATH}"

# uv (Python). Node 22 は devcontainer feature 側で入る。
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && echo 'export PATH="$HOME/.local/bin:$HOME/.grok/bin:$PATH"' >> /home/vscode/.bashrc

# Grok Build CLI. Auth is not baked in; login or XAI_API_KEY at runtime.
RUN curl -fsSL https://x.ai/cli/install.sh | bash

ENTRYPOINT ["/usr/local/bin/devcontainer-entrypoint.sh"]
CMD ["sleep", "infinity"]
