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