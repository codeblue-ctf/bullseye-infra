# bulls-eye

## Services

- [Bull's Eye Web](https://github.com/codeblue-ctf/bullseye-web) (including admin CMS)
- [Bull's Eye Runner](https://github.com/codeblue-ctf/bullseye-runner)
- [Bull's Eye Docker Registry](https://github.com/codeblue-ctf/bullseye-docker-registry)

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

### Bull's Eye Web

See Bull's Eye Web instruction

### Bull's Eye Runner

See Bull's Eye Runner instruction

### Docker Registry & Docker Registry Auth

See Bull's Eye Docker Registry instruction
