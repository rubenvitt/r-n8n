FROM n8nio/n8n:latest

USER root

# We don't need the standalone Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
RUN apk update && apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    yarn \
    chromium-chromedriver \
    xvfb \
    dbus \
    mesa-gl \
    libxcomposite \
    libxdamage \
    libxrandr \
    libgcc \
    libxi \
    libxscrnsaver \
    libxtst

# Setzen Sie die Chromium-Umgebungsvariablen
ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Fügen Sie diese Zeile nach den ENV-Variablen hinzu
ENV PUPPETEER_ARGS="--no-sandbox,--disable-setuid-sandbox,--disable-dev-shm-usage"

RUN npm install puppeteer

# Erstellen Sie das Verzeichnis für Chrome und setzen Sie die Berechtigungen
RUN mkdir -p /home/node/.cache/puppeteer && \
    chown -R node:node /home/node/.cache

# Wechseln Sie zurück zum n8n Benutzer für bessere Sicherheit
USER node
