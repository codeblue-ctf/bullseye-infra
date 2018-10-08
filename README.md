# bulls-eye

## Services

- [Bulls Eye Web](https://gitlab.com/CBCTF/bulls-eye-web) (including admin CMS)
- [Bulls Eye Runner](https://gitlab.com/CBCTF/bulls-eye-runner)
- [Bulls Eye Docker Registry](https://gitlab.com/CBCTF/bulls-eye-docker-registry)

Overview: <https://gitlab.com/CBCTF/bulls-eye/wikis/Overview>

## Deployment instructions

```bash
$ git submodule init
$ git submodule update
$ cp master.key web/config/master.key # copy bulls-eye-web master key
$ ./docker-registry/generate-sample-config.sh
$ docker-compose up
```

### Bulls Eye Web

See Bulls Eye Web instruction

### Bulls Eye Runner

See Bulls Eye Runner instruction

### Docker Registry & Docker Registry Auth

See Bulls Eye Docker Registry instruction
