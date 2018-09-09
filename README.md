# bulls-eye

## Services

- [Bulls Eye Web](https://gitlab.com/CBCTF/bulls-eye-web) (including admin CMS)
- [Bulls Eye Runner](https://gitlab.com/CBCTF/bulls-eye-runner)
- Docker Registry

Overview: <https://gitlab.com/CBCTF/bulls-eye/wikis/Overview>

## Configuration

### Generate server certificate for Docker Registry Auth

```sh
$ openssl req -nodes -newkey rsa:4096 -keyout config/certs/server.key -out config/certs/server.csr -subj "/CN=dockerauth"
$ openssl x509 -in config/certs/server.csr -out config/certs/server.crt -req -signkey config/certs/server.key -days 3650
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
