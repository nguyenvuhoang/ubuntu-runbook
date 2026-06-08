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