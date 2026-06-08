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