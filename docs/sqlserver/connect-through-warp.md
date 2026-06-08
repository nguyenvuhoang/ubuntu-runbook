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