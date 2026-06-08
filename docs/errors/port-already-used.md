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