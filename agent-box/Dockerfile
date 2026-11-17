FROM node:22-bookworm

# Core development utilities and Playwright Chromium runtime dependencies for Debian 12.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ripgrep fd-find jq sqlite3 python3 python3-pip python3-venv \
    fonts-noto-color-emoji fonts-unifont libfontconfig1 libfreetype6 \
    xfonts-scalable fonts-liberation fonts-ipafont-gothic fonts-wqy-zenhei \
    fonts-tlwg-loma-otf fonts-freefont-ttf xvfb \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcairo2 \
    libcups2 libdbus-1-3 libdrm2 libgbm1 libglib2.0-0 libnspr4 libnss3 \
    libpango-1.0-0 libx11-6 libxcb1 libxcomposite1 libxdamage1 libxext6 \
    libxfixes3 libxkbcommon0 libxrandr2 \
    && rm -rf /var/lib/apt/lists/*

# Global CLI agents
RUN npm install -g @openai/codex opencode-ai

# Pre-create persistent volume directories owned by node.
RUN mkdir -p /home/node/.codex /home/node/.config/opencode /home/node/.local/share/opencode /home/node/.cache/ms-playwright && chown -R node:node /home/node

USER node
WORKDIR /workspace
