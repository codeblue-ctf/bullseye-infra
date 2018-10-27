node.reverse_merge!(
  docker: {
    users: [ node[:user] ]
  }
)

include_recipe "../../cookbooks/deploy_key"
include_recipe "../../cookbooks/known_hosts"
include_recipe "docker::install"
include_recipe "../../cookbooks/docker-compose"
include_recipe "../../cookbooks/nodejs"
