# 使用標準 Alpine 版本的 Node.js 作為基礎（有 apk 套件管理器）
FROM node:20-alpine

# 設定 n8n 版本
ARG N8N_VERSION=latest

# 安裝必要的系統依賴和 yt-dlp
RUN apk add --update --no-cache \
    tini \
    su-exec \
    ffmpeg \
    python3 \
    py3-pip \
    curl \
    && rm -rf /var/cache/apk/*

# 安裝 n8n
RUN npm install -g n8n@${N8N_VERSION}

# 安裝 yt-dlp（透過 pip）
RUN pip3 install --no-cache-dir --break-system-packages yt-dlp

# 建立 node 用戶的下載目錄
RUN mkdir -p /home/node/.n8n /home/node/downloads \
    && chown -R node:node /home/node

WORKDIR /home/node

# 使用 node 用戶運行
USER node

EXPOSE 5678

ENTRYPOINT ["tini", "--"]
CMD ["n8n", "start"]
