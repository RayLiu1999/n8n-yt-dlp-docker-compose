# n8n-yt-dlp-docker-compose

[English Version](README_EN.md) | 中文版

這是一個使用 Docker Compose 部署的 n8n 工作流自動化平台，整合了 yt-dlp 工具，用於影片下載和處理。

## 功能特點

- 使用 Docker Compose 進行簡易部署和管理
- 整合 n8n 工作流自動化平台
- 內建 yt-dlp 工具，支援多種網站的影片下載
- 預設配置 ffmpeg 用於影片處理
- 自動設置時區為亞洲/台北
- 持久化數據存儲

## 系統需求

- Docker
- Docker Compose
- 足夠的磁碟空間用於存儲下載的媒體文件

## 快速開始

### 1. 克隆儲存庫

```bash
git clone https://github.com/RayLiu1999/n8n-yt-dlp-docker-compose.git
cd n8n-yt-dlp-docker-compose
```

### 2. 配置環境變數

創建 `.env` 文件並設置必要的環境變數：

```bash
# 創建環境變數文件
touch .env
```

可以在 `.env` 文件中添加 n8n 所需的環境變數。

### 3. 啟動服務

```bash
docker-compose up -d
```

### 4. 訪問 n8n

服務啟動後，可以通過瀏覽器訪問：

```
http://localhost:5678
```

## 目錄結構

- `/var/www/html/downloads`: 下載的媒體文件存儲位置
- `n8n_data`: n8n 數據持久化卷

## 自定義配置

### 修改下載目錄

如需更改下載目錄，請編輯 `docker-compose.yml` 文件中的卷映射：

```yaml
volumes:
  - n8n_data:/home/node/.n8n
  - /your/custom/path:/home/node/downloads
  - ./entrypoint.sh:/entrypoint.sh
```

### 修改端口

如需更改 n8n 的訪問端口，請編輯 `docker-compose.yml` 文件中的端口映射：

```yaml
ports:
  - "your_port:5678"
```

## 使用 yt-dlp

在 n8n 工作流中，可以使用 Execute Command 節點來執行 yt-dlp 命令，例如：

```
yt-dlp -o "/home/node/downloads/%(title)s.%(ext)s" [URL]
```

## 維護與更新

### 更新容器

```bash
docker-compose pull
docker-compose up -d
```

### 查看日誌

```bash
docker-compose logs -f
```

## 授權

請參閱 LICENSE 文件了解更多信息。

## 貢獻

歡迎提交問題和改進建議！
