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