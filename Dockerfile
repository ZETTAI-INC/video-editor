FROM node:20-slim

# Install system dependencies: FFmpeg, Python3, pip
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Create Python venv and install Whisper
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir openai-whisper

# Install Chromium for Remotion rendering
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

WORKDIR /app

# Copy package files first for caching
COPY package.json package-lock.json* ./
RUN npm install

# Copy all source files
COPY . .

# Create necessary directories
RUN mkdir -p public output

# Expose port (Render sets PORT env automatically)
EXPOSE 10000

# Start the server
CMD ["npx", "tsx", "server.ts"]
