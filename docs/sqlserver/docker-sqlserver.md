# SQL Server with Docker

## Run SQL Server container

```bash
docker run -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=YourStrongPassword@123" \
  -p 1433:1433 \
  --name sqlserver \
  --restart always \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

## Check container

```bash
docker ps
```

## Check logs

```bash
docker logs -f sqlserver
```

## Tags

`sqlserver`, `docker`, `mssql`, `1433`