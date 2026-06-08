# Fix YAML Tab Character

## Error

```bash
yaml: while scanning a plain scalar
found a tab character that violates indentation
```

## Cause

YAML does not allow tab characters for indentation. Use spaces only.

## Find tab characters

```bash
grep -nP '\t' docker-compose.yml
```

## Replace tabs with two spaces

```bash
sed -i 's/\t/  /g' docker-compose.yml
```

## Validate Docker Compose file

```bash
docker compose config
```

## Run again

```bash
docker compose up -d
```

## Tags

`yaml`, `docker-compose`, `ubuntu`, `tab`, `indentation`