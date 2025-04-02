# n8n-yt-dlp-docker-compose

English | [中文版](README.md)

This is an n8n workflow automation platform deployed using Docker Compose, integrated with yt-dlp tool for video downloading and processing.

## Features

- Easy deployment and management with Docker Compose
- Integration with n8n workflow automation platform
- Built-in yt-dlp tool supporting video downloads from various websites
- Pre-configured ffmpeg for video processing
- Automatic timezone setting to Asia/Taipei
- Persistent data storage

## System Requirements

- Docker
- Docker Compose
- Sufficient disk space for storing downloaded media files

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/RayLiu1999/n8n-yt-dlp-docker-compose.git
cd n8n-yt-dlp-docker-compose
```

### 2. Configure Environment Variables

Create a `.env` file and set the necessary environment variables:

```bash
# Create environment variable file
touch .env
```

You can add environment variables required by n8n in the `.env` file.

### 3. Start the Service

```bash
docker-compose up -d
```

### 4. Access n8n

After the service starts, you can access it through your browser:

```
http://localhost:5678
```

## Directory Structure

- `/var/www/html/downloads`: Storage location for downloaded media files
- `n8n_data`: Persistent volume for n8n data

## Custom Configuration

### Modify Download Directory

To change the download directory, edit the volume mapping in the `docker-compose.yml` file:

```yaml
volumes:
  - n8n_data:/home/node/.n8n
  - /your/custom/path:/home/node/downloads
  - ./entrypoint.sh:/entrypoint.sh
```

### Modify Port

To change the access port for n8n, edit the port mapping in the `docker-compose.yml` file:

```yaml
ports:
  - "your_port:5678"
```

## Using n8n Workflow

This project includes a default n8n workflow `yt_dlp_video_download_and_summary.json` that provides video downloading and automatic summary generation functionality.

### Importing the Workflow

1. In the n8n interface, click on "Workflows" in the top left corner
2. Click the "Import" button
3. Select the `yt_dlp_video_download_and_summary.json` file
4. Click "Import" to complete the workflow import

### Workflow Features

This workflow provides the following features:

1. **Video Download**: Supports downloading videos from various websites with different quality and format options
2. **Video Summary**: Optional automatic generation of video content summaries using the OpenAI API (requires an API key)

### Using the API Endpoint

The workflow establishes a Webhook endpoint that can be accessed via HTTP requests:

```
http://localhost:5678/webhook/download-video
```

#### Request Parameters

- `url`: The URL of the video to download (required)
- `quality`: Video quality, options: `highest`, `high`, `medium`, `low` (default is `medium`)
- `format`: Output format, options: `mp4`, `mp3` (default is `mp4`)
- `summarize`: Whether to generate a summary, options: `0`, `1` (default is `0`, no summary)
- `token`: OpenAI API key (required if `summarize=1`)
- `online`: Whether to use online mode, options: `0`, `1` (default is `0`, online mode automatically deletes files older than 1 hour)

#### Request Examples

Download video only:

```bash
curl "http://localhost:5678/webhook/download-video?url=https://www.youtube.com/watch?v=example&quality=high&format=mp4"
```

Download and generate summary:

```bash
curl "http://localhost:5678/webhook/download-video?url=https://www.youtube.com/watch?v=example&quality=medium&format=mp3&summarize=1&token=your_openai_api_key"
```

### Manual Use of yt-dlp

Besides using the default workflow, you can also use the Execute Command node in n8n workflows to directly run yt-dlp commands, for example:

```
yt-dlp -o "/home/node/downloads/%(title)s.%(ext)s" [URL]
```

## Maintenance and Updates

### Update Containers

```bash
docker-compose pull
docker-compose up -d
```

### View Logs

```bash
docker-compose logs -f
```

## License

Please refer to the LICENSE file for more information.

## Contribution

Issues and improvement suggestions are welcome!
