# Redis and RabbitMQ with Docker

## Run Redis

```bash
docker run -d \
  --name redis \
  --restart always \
  -p 6379:6379 \
  redis:7-alpine
```

## Run RabbitMQ Management

```bash
docker run -d \
  --name rabbitmq \
  --restart always \
  -p 5672:5672 \
  -p 15672:15672 \
  rabbitmq:3-management
```

## RabbitMQ UI

```txt
http://server-ip:15672
```

Default account:

```txt
guest / guest
```

## Tags

`docker`, `redis`, `rabbitmq`, `queue`, `cache`