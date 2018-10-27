# bulls-eye

## Services

- [Bulls Eye Web](https://gitlab.com/CBCTF/bulls-eye-web) (including admin CMS)
- [Bulls Eye Runner](https://gitlab.com/CBCTF/bulls-eye-runner)
- [Bulls Eye Docker Registry](https://gitlab.com/CBCTF/bulls-eye-docker-registry)

Overview: <https://gitlab.com/CBCTF/bulls-eye/wikis/Overview>

## Deployment instructions

### Get secret key

Set secret key to `deploy/secrets/keys/default`

### For development

```bash
$ bundle install --path=vendor/bundle
$ cd deploy
$ vagrant up
$ ./deploy_vagrant.sh
```

### For production

TODO: create Rakefile to do the same thing

```bash
$ bundle exec itamae ssh -h PRODUCTION_HOST -y nodes/production/$ROLE.yml deploy/entry.rb
```

### Bulls Eye Web

See Bulls Eye Web instruction

### Bulls Eye Runner

See Bulls Eye Runner instruction

### Docker Registry & Docker Registry Auth

See Bulls Eye Docker Registry instruction
