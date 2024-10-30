FROM n8nio/n8n:latest

USER root

# Setzen Sie Umgebungsvariablen
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    PUPPETEER_ARGS="--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu" \
    NODE_PATH=/usr/local/lib/node_modules

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
    xvfb \
    udev \
    ttf-liberation \
    font-noto

# Installieren Sie Puppeteer global und in das n8n-Verzeichnis
RUN npm install -g puppeteer@19.11.1 && \
    cd /usr/local/lib/node_modules/n8n && \
    npm install puppeteer@19.11.1

# Erstellen Sie benötigte Verzeichnisse und setzen Sie Berechtigungen
RUN mkdir -p /home/node/.cache/puppeteer && \
    mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    chown -R node:node /home/node && \
    chown -R node:node /usr/local/lib/node_modules

# Setzen Sie die Display-Umgebungsvariable für Xvfb
ENV DISPLAY=:99

# Erstellen Sie ein verbessertes Startskript
RUN echo '#!/bin/sh\n\
Xvfb :99 -screen 0 1024x768x16 &\n\
sleep 1\n\
export DISPLAY=:99\n\
exec n8n\n\
' > /start.sh && \
    chmod +x /start.sh

USER node

# Überschreiben Sie den Standard-Entrypoint
ENTRYPOINT ["/start.sh"]
