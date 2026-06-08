# Docker Logs

## View container logs

```bash
docker logs container-name
```

## Follow logs

```bash
docker logs -f container-name
```

## Show last 100 lines

```bash
docker logs --tail 100 container-name
```

## Logs with timestamp

```bash
docker logs -f --timestamps container-name
```

## Docker Compose logs

```bash
docker compose logs -f service-name
```

## Tags

`docker`, `logs`, `debug`, `container`