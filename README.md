# bulls-eye

## Services

- [Bulls Eye Web](https://github.com/codeblue-ctf/bulls-eye-web) (including admin CMS)
- [Bulls Eye Runner](https://github.com/codeblue-ctf/bulls-eye-runner)
- [Bulls Eye Docker Registry](https://github.com/codeblue-ctf/bulls-eye-docker-registry)

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
$ bundle exec itamae ssh -h PRODUCTION_HOST -y deploy/nodes/production/$ROLE.yml deploy/entry.rb
```

### Bulls Eye Web

See Bulls Eye Web instruction

### Bulls Eye Runner

See Bulls Eye Runner instruction

### Docker Registry & Docker Registry Auth

See Bulls Eye Docker Registry instruction
