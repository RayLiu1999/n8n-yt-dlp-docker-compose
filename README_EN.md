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

## Using yt-dlp

In n8n workflows, you can use the Execute Command node to run yt-dlp commands, for example:

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
