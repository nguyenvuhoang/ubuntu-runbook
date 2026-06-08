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