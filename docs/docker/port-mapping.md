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