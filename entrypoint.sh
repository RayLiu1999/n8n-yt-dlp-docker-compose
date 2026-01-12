#!/bin/sh

# 安裝必要的軟件包
apk update
apk add --no-cache ffmpeg curl python3 py3-pip || apk add --no-cache ffmpeg curl python3 python3-pip

# 創建下載目錄（如果不存在）
mkdir -p /home/node/downloads

# 下載 yt-dlp 並設置執行權限
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
chmod a+rx /usr/local/bin/yt-dlp

# 創建 python3 的软鏈接
ln -sf /usr/bin/python3 /usr/local/bin/python

# 設置權限，讓 node 用戶有權限存取下載目錄
chown -R node:node /home/node/downloads

# 正確的啟動方式：使用 exec 切換用戶並接管進程
exec su-exec node n8n start