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