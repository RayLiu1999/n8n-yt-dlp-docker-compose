# 階段 1：使用 Alpine 下載 ffmpeg 和準備 apk 工具
FROM --platform=$BUILDPLATFORM alpine:latest AS builder

# 宣告目標架構變數
ARG TARGETARCH

# 安裝必要工具和靜態 apk 工具
RUN apk add --no-cache curl xz apk-tools-static

# 下載靜態編譯的 ffmpeg（根據架構選擇正確版本）
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz -o /tmp/ffmpeg.tar.xz; \
    else \
        curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -o /tmp/ffmpeg.tar.xz; \
    fi && \
    cd /tmp && \
    tar xf ffmpeg.tar.xz && \
    mv ffmpeg-*-static/ffmpeg /ffmpeg && \
    mv ffmpeg-*-static/ffprobe /ffprobe && \
    chmod a+rx /ffmpeg /ffprobe

# 階段 2：最終的 n8n image（Hardened Alpine）
FROM docker.n8n.io/n8nio/n8n:latest

USER root

# 從 builder 複製靜態 apk 工具
COPY --from=builder /sbin/apk.static /sbin/apk

# 配置 apk 倉庫 (Hardened image 可能缺少倉庫配置)
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.20/main" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v3.20/community" >> /etc/apk/repositories

# 安裝 Python 和 pip
# 使用靜態 apk 安裝
RUN /sbin/apk add --no-cache --initdb --allow-untrusted \
    python3 \
    py3-pip \
    bash \
    curl \
    ca-certificates

# 安裝 yt-dlp
RUN pip3 install --break-system-packages yt-dlp

# 從 builder 階段複製 ffmpeg 二進位檔案
COPY --from=builder /ffmpeg /usr/local/bin/ffmpeg
COPY --from=builder /ffprobe /usr/local/bin/ffprobe

USER node
