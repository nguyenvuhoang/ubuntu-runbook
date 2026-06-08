# Serve Static HTML with Docker Nginx

## Folder structure

```txt
app/
  html/
    index.html
  docker-compose.yml
```

## docker-compose.yml

```yaml
services:
  nginx:
    image: nginx:alpine
    container_name: static-nginx
    restart: always
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
```

## Start

```bash
docker compose up -d
```

## Open

```txt
http://server-ip:8080
```

## Tags

`nginx`, `docker`, `html`, `static-site`