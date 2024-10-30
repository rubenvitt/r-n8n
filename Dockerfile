FROM n8nio/n8n:latest

USER root

# We don't need the standalone Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    PUPPETEER_ARGS="--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu"

# Install Chromium and dependencies
RUN apk update && apk add --no-cache \
    chromium \
    chromium-chromedriver \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    yarn \
    dbus \
    mesa-gl \
    libxcomposite \
    libxdamage \
    libxrandr \
    libgcc \
    libxi \
    libxscrnsaver \
    libxtst \
    libx11 \
    libxext \
    libxfixes \
    libxrender \
    libxcb \
    xvfb

# Install puppeteer globally
RUN npm install -g puppeteer@19.11.1

# Erstellen Sie benötigte Verzeichnisse und setzen Sie Berechtigungen
RUN mkdir -p /home/node/.cache/puppeteer && \
    mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    chown -R node:node /home/node

# Setzen Sie die Display-Umgebungsvariable für Xvfb
ENV DISPLAY=:99

# Erstellen Sie ein Startskript
RUN echo '#!/bin/sh\nXvfb :99 -screen 0 1024x768x16 & n8n' > /start.sh && \
    chmod +x /start.sh

USER node

# Überschreiben Sie den Standard-Entrypoint
ENTRYPOINT ["/start.sh"]
