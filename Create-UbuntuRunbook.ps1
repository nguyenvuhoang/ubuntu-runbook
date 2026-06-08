param(
    [string]$RootPath = "D:\1.ENVIRONMENT\53.JITS\ubuntu-runbook",
    [switch]$ForceOverwrite,
    [switch]$InitGit
)

$ErrorActionPreference = "Stop"

function Write-RunbookFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Content
    )

    $directory = Split-Path -Parent $Path
    if (-not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    if ((Test-Path $Path) -and (-not $ForceOverwrite)) {
        Write-Host "SKIP  $Path" -ForegroundColor Yellow
        return
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false
    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
    Write-Host "WRITE $Path" -ForegroundColor Green
}

function Ensure-Directory {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "DIR   $Path" -ForegroundColor Cyan
    }
}

Write-Host "Ubuntu Runbook Setup" -ForegroundColor Cyan
Write-Host "RootPath: $RootPath" -ForegroundColor Cyan

Ensure-Directory -Path $RootPath

$directories = @(
    "docs",
    "docs\ubuntu",
    "docs\docker",
    "docs\nginx",
    "docs\cloudflare",
    "docs\sqlserver",
    "docs\git",
    "docs\errors",
    "docs\templates",
    "scripts"
)

foreach ($dir in $directories) {
    Ensure-Directory -Path (Join-Path $RootPath $dir)
}

$files = [ordered]@{}

$files[".gitignore"] = @'
site/
.cache/
__pycache__/
*.pyc
.env
.vscode/
.idea/
.DS_Store
Thumbs.db
'@

$files["README.md"] = @'
# Ubuntu Runbook

Personal DevOps knowledge base for Ubuntu, Docker, Nginx, Cloudflare, SQL Server, Git, and common production errors.

## Purpose

This repo stores useful commands and troubleshooting notes that are easy to search, reuse, and update.

## Local preview

```powershell
mkdocs serve
```

Open:

```txt
http://127.0.0.1:8000
```

## Build static HTML

```powershell
mkdocs build
```

## Deploy to GitHub Pages

```powershell
mkdocs gh-deploy
```

## Suggested workflow

1. Create one markdown file per issue.
2. Keep the title short and searchable.
3. Add exact error message.
4. Add root cause.
5. Add commands to fix.
6. Add verification commands.
7. Add tags at the end.
'@

$files["mkdocs.yml"] = @'
site_name: Ubuntu Runbook
site_description: Personal DevOps fix notes for Ubuntu, Docker, Nginx, Cloudflare, SQL Server, and Git
site_author: BEN

theme:
  name: material
  language: en
  features:
    - navigation.tabs
    - navigation.sections
    - navigation.top
    - search.highlight
    - search.suggest
    - content.code.copy
    - content.code.select

markdown_extensions:
  - admonition
  - toc:
      permalink: true
  - pymdownx.details
  - pymdownx.superfences
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.inlinehilite
  - pymdownx.snippets

nav:
  - Home: index.md
  - Ubuntu:
      - Check RAM: ubuntu/check-ram.md
      - Check Disk: ubuntu/check-disk.md
      - Permission Denied: ubuntu/permission-denied.md
      - Systemctl Service: ubuntu/service-systemctl.md
  - Docker:
      - Docker Compose: docker/docker-compose.md
      - Port Mapping: docker/port-mapping.md
      - Docker Logs: docker/docker-logs.md
      - Redis RabbitMQ: docker/redis-rabbitmq.md
  - Nginx:
      - Reverse Proxy: nginx/reverse-proxy.md
      - Fix 502: nginx/fix-502.md
      - Docker Nginx HTML: nginx/docker-nginx-html.md
  - Cloudflare:
      - WARP Private Network: cloudflare/warp-private-network.md
      - Tunnel to Nginx: cloudflare/tunnel-to-nginx.md
      - SQL Server Private CIDR: cloudflare/sqlserver-private-cidr.md
  - SQL Server:
      - Docker SQL Server: sqlserver/docker-sqlserver.md
      - Open Port 1433: sqlserver/open-port-1433.md
      - Connect Through WARP: sqlserver/connect-through-warp.md
  - Git:
      - Fix Existing Tag: git/tag-would-clobber-existing-tag.md
      - Divergent Branch: git/divergent-branch.md
  - Errors:
      - YAML Tab Character: errors/yaml-tab-character.md
      - Port Already Used: errors/port-already-used.md
      - Systemctl Service Not Found: errors/systemctl-service-not-found.md
  - Templates:
      - Runbook Note Template: templates/runbook-note-template.md
'@

$files["docs\index.md"] = @'
# Ubuntu Runbook

Welcome to the personal DevOps runbook.

Use this documentation to quickly find commands and fixes for repeated Ubuntu, Docker, Nginx, Cloudflare, SQL Server, and Git issues.

## Main categories

- Ubuntu
- Docker
- Nginx
- Cloudflare
- SQL Server
- Git
- Errors

## Quick search keywords

```txt
yaml tab
docker port
cloudflare tunnel
sqlserver 1433
nginx 502
permission denied
systemctl service not found
```

## Standard note structure

Each note should include:

1. Error or situation
2. Root cause
3. Fix commands
4. Verification commands
5. Tags
'@

$files["docs\templates\runbook-note-template.md"] = @'
# Title here

## When to use

Describe when this note is useful.

## Error message

```bash
paste error here
```

## Root cause

Explain the reason shortly.

## Fix

```bash
command here
```

## Verify

```bash
command here
```

## Notes

- Server:
- Service:
- Port:
- Date:

## Tags

`ubuntu`, `docker`, `nginx`, `cloudflare`, `sqlserver`, `git`
'@

$files["docs\ubuntu\check-ram.md"] = @'
# Check RAM on Ubuntu or Linux

## Check total memory

```bash
free -h
```

## Check memory by process

```bash
top
```

If `htop` is available:

```bash
htop
```

## Install htop on Ubuntu or Debian

```bash
sudo apt update
sudo apt install htop -y
```

## Install htop on CentOS, RHEL, Rocky, AlmaLinux

```bash
sudo yum install htop -y
```

or:

```bash
sudo dnf install htop -y
```

## Tags

`linux`, `ubuntu`, `ram`, `memory`, `htop`, `top`
'@

$files["docs\ubuntu\check-disk.md"] = @'
# Check Disk on Ubuntu or Linux

## Check disk usage

```bash
df -h
```

## Check folder size

```bash
du -sh /path/to/folder
```

## Find large folders

```bash
sudo du -h --max-depth=1 / | sort -hr | head -20
```

## Find large files

```bash
sudo find / -type f -size +500M -exec ls -lh {} \; 2>/dev/null
```

## Check mounted disks

```bash
lsblk
```

## Tags

`linux`, `ubuntu`, `disk`, `storage`, `df`, `du`, `lsblk`
'@

$files["docs\ubuntu\permission-denied.md"] = @'
# Fix Permission Denied

## Common error

```bash
Permission denied
```

## Check owner and permission

```bash
ls -lah /path/to/file-or-folder
```

## Change owner

```bash
sudo chown -R $USER:$USER /path/to/folder
```

## Add execute permission

```bash
chmod +x script.sh
```

## Fix Docker volume log folder permission

```bash
sudo mkdir -p /var/log/ips/o24log
sudo chown -R 1000:1000 /var/log/ips/o24log
sudo chmod -R 755 /var/log/ips/o24log
```

## Tags

`linux`, `ubuntu`, `permission`, `chown`, `chmod`, `docker-volume`
'@

$files["docs\ubuntu\service-systemctl.md"] = @'
# Manage Services with systemctl

## Check service status

```bash
sudo systemctl status service-name
```

## Start service

```bash
sudo systemctl start service-name
```

## Stop service

```bash
sudo systemctl stop service-name
```

## Enable service on boot

```bash
sudo systemctl enable service-name
```

## Enable and start now

```bash
sudo systemctl enable --now service-name
```

## List services

```bash
systemctl list-units --type=service
```

## Tags

`linux`, `ubuntu`, `systemctl`, `service`, `daemon`
'@

$files["docs\docker\docker-compose.md"] = @'
# Docker Compose Commands

## Start services

```bash
docker compose up -d
```

## Stop services

```bash
docker compose down
```

## Recreate containers

```bash
docker compose up -d --force-recreate
```

## Pull latest images

```bash
docker compose pull
```

## Validate compose file

```bash
docker compose config
```

## View containers

```bash
docker ps
```

## Tags

`docker`, `docker-compose`, `compose`, `container`
'@

$files["docs\docker\port-mapping.md"] = @'
# Docker Port Mapping

## Format

```yaml
ports:
  - "HOST_PORT:CONTAINER_PORT"
```

Example:

```yaml
ports:
  - "5030:5030"
  - "5031:5031"
```

## Check listening ports on host

```bash
sudo ss -tulpn
```

Filter a port:

```bash
sudo ss -tulpn | grep 1433
```

## Check Docker published ports

```bash
docker ps
```

## Tags

`docker`, `port`, `mapping`, `ss`, `container`
'@

$files["docs\docker\docker-logs.md"] = @'
# Docker Logs

## View container logs

```bash
docker logs container-name
```

## Follow logs

```bash
docker logs -f container-name
```

## Show last 100 lines

```bash
docker logs --tail 100 container-name
```

## Logs with timestamp

```bash
docker logs -f --timestamps container-name
```

## Docker Compose logs

```bash
docker compose logs -f service-name
```

## Tags

`docker`, `logs`, `debug`, `container`
'@

$files["docs\docker\redis-rabbitmq.md"] = @'
# Redis and RabbitMQ with Docker

## Run Redis

```bash
docker run -d \
  --name redis \
  --restart always \
  -p 6379:6379 \
  redis:7-alpine
```

## Run RabbitMQ Management

```bash
docker run -d \
  --name rabbitmq \
  --restart always \
  -p 5672:5672 \
  -p 15672:15672 \
  rabbitmq:3-management
```

## RabbitMQ UI

```txt
http://server-ip:15672
```

Default account:

```txt
guest / guest
```

## Tags

`docker`, `redis`, `rabbitmq`, `queue`, `cache`
'@

$files["docs\nginx\reverse-proxy.md"] = @'
# Nginx Reverse Proxy

## Basic reverse proxy config

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Test config

```bash
sudo nginx -t
```

## Reload Nginx

```bash
sudo systemctl reload nginx
```

## Tags

`nginx`, `reverse-proxy`, `proxy-pass`, `linux`
'@

$files["docs\nginx\fix-502.md"] = @'
# Fix Nginx 502 Bad Gateway

## Error

```txt
502 Bad Gateway
```

## Common causes

- Backend service is down.
- Wrong backend port.
- Backend listens only on localhost or different interface.
- Firewall blocks connection.
- HTTPS backend uses self-signed certificate.

## Check backend from server

```bash
curl -vk https://127.0.0.1:5000/api/index.html
```

or:

```bash
curl -v http://127.0.0.1:5000
```

## Check Nginx config

```bash
sudo nginx -t
```

## Check Nginx logs

```bash
sudo tail -f /var/log/nginx/error.log
```

## Restart Nginx

```bash
sudo systemctl restart nginx
```

## Tags

`nginx`, `502`, `bad-gateway`, `reverse-proxy`, `backend`
'@

$files["docs\nginx\docker-nginx-html.md"] = @'
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
'@

$files["docs\cloudflare\warp-private-network.md"] = @'
# Cloudflare WARP Private Network

## Purpose

Use Cloudflare WARP and Zero Trust private network to access internal private IPs without exposing ports publicly.

## Typical checks

Check WARP connection on client:

```powershell
warp-cli status
```

Check TCP connection from Windows:

```powershell
Test-NetConnection 172.22.38.95 -Port 1433
```

## Common issue

If WARP is connected but private IP is not reachable, check:

- Device is enrolled into the correct Zero Trust team.
- Split tunnel includes the private CIDR.
- The server route exists in Cloudflare private network.
- Firewall allows the target port.

## Tags

`cloudflare`, `warp`, `zero-trust`, `private-network`, `cidr`
'@

$files["docs\cloudflare\tunnel-to-nginx.md"] = @'
# Cloudflare Tunnel to Nginx

## Purpose

Expose an internal Nginx service through Cloudflare Tunnel without opening public inbound ports.

## Example public hostname mapping

```txt
cms.example.com -> http://localhost:5000
```

or via Nginx:

```txt
cms.example.com -> http://localhost:80
```

## Check local service

```bash
curl -v http://127.0.0.1:5000
```

## Check Nginx

```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Tags

`cloudflare`, `tunnel`, `nginx`, `public-hostname`, `zero-trust`
'@

$files["docs\cloudflare\sqlserver-private-cidr.md"] = @'
# SQL Server Through Cloudflare Private CIDR

## Goal

Allow team members to connect to SQL Server on private IP through Cloudflare WARP.

## Check SQL Server port on Linux host

```bash
sudo ss -tulpn | grep 1433
```

Expected:

```txt
0.0.0.0:1433
```

## Allow firewall port

```bash
sudo ufw allow 1433/tcp
```

## Test from Windows client

```powershell
Test-NetConnection 172.22.38.95 -Port 1433
```

## SQL Server connection example

```txt
Server=172.22.38.95,1433;User Id=sa;Password=your-password;TrustServerCertificate=True;
```

## Tags

`cloudflare`, `warp`, `sqlserver`, `1433`, `private-cidr`
'@

$files["docs\sqlserver\docker-sqlserver.md"] = @'
# SQL Server with Docker

## Run SQL Server container

```bash
docker run -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=YourStrongPassword@123" \
  -p 1433:1433 \
  --name sqlserver \
  --restart always \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

## Check container

```bash
docker ps
```

## Check logs

```bash
docker logs -f sqlserver
```

## Tags

`sqlserver`, `docker`, `mssql`, `1433`
'@

$files["docs\sqlserver\open-port-1433.md"] = @'
# Open SQL Server Port 1433

## Check listening port

```bash
sudo ss -tulpn | grep 1433
```

## Allow UFW

```bash
sudo ufw allow 1433/tcp
sudo ufw status
```

## Check Docker published port

```bash
docker ps
```

## Test from Windows

```powershell
Test-NetConnection SERVER_IP -Port 1433
```

## Tags

`sqlserver`, `1433`, `firewall`, `ufw`, `docker`
'@

$files["docs\sqlserver\connect-through-warp.md"] = @'
# Connect SQL Server Through WARP

## Client test

```powershell
Test-NetConnection 172.22.38.95 -Port 1433
```

## Server test

```bash
sudo ss -tulpn | grep 1433
```

## Common checklist

- SQL Server container is running.
- Port `1433` is published.
- SQL Server listens on `0.0.0.0`.
- WARP client is connected.
- Cloudflare private route includes server CIDR.
- Device profile allows private network access.

## Tags

`sqlserver`, `cloudflare`, `warp`, `1433`, `private-network`
'@

$files["docs\git\tag-would-clobber-existing-tag.md"] = @'
# Fix Git Tag Would Clobber Existing Tag

## Error

```bash
! [rejected] v0.159.28 -> v0.159.28 (would clobber existing tag)
```

## Cause

A local tag has the same name as the remote tag but points to a different commit.

## Fix one tag

```bash
git tag -d v0.159.28
git fetch origin tag v0.159.28
```

## Fix all tags by refreshing from remote

```bash
git fetch --tags --force
```

## Verify

```bash
git tag -l | grep v0.159.28
```

## Tags

`git`, `tag`, `fetch`, `clobber`, `origin`
'@

$files["docs\git\divergent-branch.md"] = @'
# Fix Git Divergent Branch

## Error

```bash
fatal: Need to specify how to reconcile divergent branches.
```

## Option 1: merge pull

```bash
git config pull.rebase false
git pull
```

## Option 2: rebase pull

```bash
git config pull.rebase true
git pull
```

## Option 3: fast-forward only

```bash
git config pull.ff only
git pull
```

## Set globally

```bash
git config --global pull.rebase false
```

## Tags

`git`, `pull`, `rebase`, `merge`, `divergent-branch`
'@

$files["docs\errors\yaml-tab-character.md"] = @'
# Fix YAML Tab Character

## Error

```bash
yaml: while scanning a plain scalar
found a tab character that violates indentation
```

## Cause

YAML does not allow tab characters for indentation. Use spaces only.

## Find tab characters

```bash
grep -nP '\t' docker-compose.yml
```

## Replace tabs with two spaces

```bash
sed -i 's/\t/  /g' docker-compose.yml
```

## Validate Docker Compose file

```bash
docker compose config
```

## Run again

```bash
docker compose up -d
```

## Tags

`yaml`, `docker-compose`, `ubuntu`, `tab`, `indentation`
'@

$files["docs\errors\port-already-used.md"] = @'
# Fix Port Already Used

## Error

```txt
port is already allocated
address already in use
```

## Find process using port on Linux

```bash
sudo ss -tulpn | grep PORT
```

Example:

```bash
sudo ss -tulpn | grep 8080
```

## Find process using port on Windows

```powershell
netstat -ano | findstr :8080
```

Kill by PID:

```powershell
taskkill /PID 1234 /F
```

## Docker check

```bash
docker ps
```

## Tags

`port`, `docker`, `linux`, `windows`, `netstat`, `ss`
'@

$files["docs\errors\systemctl-service-not-found.md"] = @'
# Fix systemctl Service Not Found

## Error

```bash
Failed to enable unit: Unit cloudflare.service does not exist
```

## Cause

The service name is wrong or the package has not installed a systemd service.

## Search service

```bash
systemctl list-unit-files | grep -i cloudflare
```

or:

```bash
systemctl list-units --type=service | grep -i cloudflare
```

## Check installed command

```bash
which cloudflared
cloudflared --version
```

## Common Cloudflare Tunnel service name

Usually Cloudflare Tunnel uses:

```bash
sudo systemctl status cloudflared
```

Enable and start:

```bash
sudo systemctl enable --now cloudflared
```

## Tags

`systemctl`, `service`, `cloudflare`, `cloudflared`, `linux`
'@

$files["scripts\new-note.ps1"] = @'
param(
    [Parameter(Mandatory = $true)][string]$Category,
    [Parameter(Mandatory = $true)][string]$Slug,
    [string]$Title = "New Runbook Note"
)

$RootPath = Split-Path -Parent $PSScriptRoot
$TargetDir = Join-Path $RootPath "docs\$Category"
$TargetFile = Join-Path $TargetDir "$Slug.md"

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

if (Test-Path $TargetFile) {
    Write-Host "File already exists: $TargetFile" -ForegroundColor Yellow
    exit 1
}

$Content = @"
# $Title

## When to use

Describe when this note is useful.

## Error message

````bash
paste error here
````

## Root cause

Explain the reason shortly.

## Fix

````bash
command here
````

## Verify

````bash
command here
````

## Tags

``$Category``, ``$Slug``
"@

$utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false
[System.IO.File]::WriteAllText($TargetFile, $Content, $utf8NoBom)
Write-Host "Created: $TargetFile" -ForegroundColor Green
'@

foreach ($relativePath in $files.Keys) {
    $targetPath = Join-Path $RootPath $relativePath
    Write-RunbookFile -Path $targetPath -Content $files[$relativePath]
}

if ($InitGit) {
    Push-Location $RootPath
    try {
        if (-not (Test-Path ".git")) {
            git init
            git add .
            git commit -m "Initial Ubuntu runbook structure"
        }
        else {
            Write-Host "Git repository already exists. Skipped git init." -ForegroundColor Yellow
        }
    }
    finally {
        Pop-Location
    }
}

Write-Host "" 
Write-Host "Done." -ForegroundColor Green
Write-Host "Next commands:" -ForegroundColor Cyan
Write-Host "  cd `"$RootPath`""
Write-Host "  mkdocs serve"
Write-Host ""
Write-Host "To overwrite existing files, run:" -ForegroundColor Cyan
Write-Host "  .\Create-UbuntuRunbook.ps1 -ForceOverwrite"
