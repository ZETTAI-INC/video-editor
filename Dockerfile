FROM node:20-slim

# Remotion + FFmpeg + curl の依存関係をまとめてインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    curl \
    ca-certificates \
    fonts-noto-cjk \
    libnss3 \
    libdbus-1-3 \
    libatk1.0-0 \
    libgbm-dev \
    libasound2 \
    libxrandr2 \
    libxkbcommon-dev \
    libxfixes3 \
    libxcomposite1 \
    libxdamage1 \
    libpango-1.0-0 \
    libcairo2 \
    libcups2 \
    libatk-bridge2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files first for caching
COPY package.json package-lock.json* ./
RUN npm install

# Remotion の Chrome Headless Shell を事前インストール
RUN npx remotion browser ensure

# Copy all source files
COPY . .

# Create necessary directories
RUN mkdir -p public output

# Expose port (Render sets PORT env automatically)
EXPOSE 10000

# Start the server
CMD ["npx", "tsx", "server.ts"]
