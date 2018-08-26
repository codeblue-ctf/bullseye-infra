# bulls-eye

## Services

- Bulls Eye Web (including admin CMS)
- Bulls Eye Runner
- Docker Registry

## Configuration

### Generate server certificate for Docker Registry Auth

```sh
$ openssl req -nodes -newkey rsa:4096 -keyout certs/server.key -out certs/server.csr -subj "/CN=dockerauth"
$ openssl x509 -in certs/server.csr -out certs/server.crt -req -signkey certs/server.key -days 3650
```

## Deployment instructions

### Bulls Eye Web

See Bulls Eye Web instruction

### Bulls Eye Runner

See Bulls Eye Runner instruction

### Docker Registry & Docker Registry Auth

```sh
$ dcoker-compose up
```

