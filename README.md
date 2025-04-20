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
- 可自定義下載路徑

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

# 設置下載路徑（可選，預設為 /var/www/html/downloads）
echo "DOWNLOAD_PATH=/your/custom/path" >> .env
```

您可以在 `.env` 文件中添加以下環境變數：

| 環境變數 | 說明 | 預設值 |
|---------|------|--------|
| DOWNLOAD_PATH | 媒體文件下載路徑 | /var/www/html/downloads |
| N8N_PORT | n8n 服務訪問端口 | 5678 |
| N8N_BASIC_AUTH_ACTIVE | 是否啟用基本認證 | false |
| N8N_BASIC_AUTH_USER | 基本認證用戶名 | - |
| N8N_BASIC_AUTH_PASSWORD | 基本認證密碼 | - |

更多 n8n 環境變數配置請參考 [n8n 官方文檔](https://docs.n8n.io/hosting/environment-variables/environment-variables/)。

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

- `/var/www/html/downloads`（預設）或您在 `.env` 中設置的 `DOWNLOAD_PATH`：下載的媒體文件存儲位置
- `n8n_data`：n8n 數據持久化卷

## 自定義配置

### 修改下載目錄

有兩種方式可以修改下載目錄：

1. **使用環境變數（推薦）**：
   在 `.env` 文件中設置 `DOWNLOAD_PATH` 變數：
   ```
   DOWNLOAD_PATH=/your/custom/path
   ```

2. **直接修改 docker-compose.yml**：
   ```yaml
   volumes:
     - n8n_data:/home/node/.n8n
     - /your/custom/path:/home/node/downloads
     - ./entrypoint.sh:/entrypoint.sh
   ```

### 修改端口

在 `.env` 文件中設置 `N8N_PORT` 變數，或直接修改 `docker-compose.yml` 文件中的端口映射：

```yaml
ports:
  - "your_port:5678"
```

## 使用 n8n 工作流程

本專案包含一個預設的 n8n 工作流程 `yt_dlp_video_download_and_summary.json`，提供影片下載和自動生成摘要功能。

### 導入工作流程

1. 在 n8n 介面中，點擊左上角的「工作流程」
2. 點擊「導入」按鈕
3. 選擇 `yt_dlp_video_download_and_summary.json` 文件
4. 點擊「導入」完成工作流程的導入

### 工作流程功能

此工作流程提供以下功能：

1. **影片下載**：支援從多種網站下載影片，可選擇不同的品質和格式
2. **影片摘要**：可選擇使用 OpenAI API 自動生成影片內容摘要（需要 API 金鑰）

### API 端點使用

工作流程建立了一個 Webhook 端點，可通過 HTTP 請求使用：

```
http://localhost:5678/webhook/download-video
```

#### 請求參數

- `url`：要下載的影片 URL（必填）
- `quality`：影片品質，可選值：`highest`、`high`、`medium`、`low`（預設為 `medium`）
- `format`：輸出格式，可選值：`mp4`、`mp3`（預設為 `mp4`）
- `summarize`：是否生成摘要，可選值：`0`、`1`（預設為 `0`，不生成摘要）
- `token`：OpenAI API 金鑰（如果 `summarize=1`，則必填）
- `online`：是否為線上模式，可選值：`0`、`1`（預設為 `0`，線上模式會自動刪除 1 小時前的檔案）

#### 請求範例

僅下載影片：

```bash
curl "http://localhost:5678/webhook/download-video?url=https://www.youtube.com/watch?v=example&quality=high&format=mp4"
```

下載並生成摘要：

```bash
curl "http://localhost:5678/webhook/download-video?url=https://www.youtube.com/watch?v=example&quality=medium&format=mp3&summarize=1&token=your_openai_api_key"
```

### 手動使用 yt-dlp

除了使用預設工作流程，您也可以在 n8n 工作流中使用 Execute Command 節點來直接執行 yt-dlp 命令，例如：

```
yt-dlp -o "/home/node/downloads/%(title)s.%(ext)s" [URL]
```

## 常見問題解決方法

### 1. 下載失敗或格式問題

如果遇到下載失敗或格式問題，可能是 yt-dlp 版本過舊。嘗試更新 yt-dlp：

```bash
docker exec -it n8n sh -c "curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && chmod a+rx /usr/local/bin/yt-dlp"
```

### 2. 權限問題

如果遇到檔案權限問題，請確保下載目錄具有正確的權限：

```bash
docker exec -it n8n sh -c "chown -R node:node /home/node/downloads"
```

### 3. 容器無法啟動

檢查 Docker 日誌以獲取更多信息：

```bash
docker-compose logs n8n
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
