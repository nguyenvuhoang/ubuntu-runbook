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