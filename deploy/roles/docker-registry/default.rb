node.reverse_merge!(
  docker: {
    users: [ node[:user] ]
  }
)

include_recipe "../../cookbooks/deploy_key"
include_recipe "../../cookbooks/known_hosts"
include_recipe "docker::install"
include_recipe "../../cookbooks/docker-compose"

# Clone bullseye docker registry
unless node[:is_vagrant] then
  git node[:app_path] do
    repository 'git@gitlab.com:CBCTF/bullseye-docker-registry.git'
    user node[:user]
  end
end

# Add environment to file
env_file = File.join(node[:app_path], '.env')
template env_file do
  source 'templates/environment'
  owner  node[:user]
  group  node[:user]
  mode   '644'
end

# Place certificates
file "#{node[:app_path]}/config/certs/server.key" do
  owner node[:user]
  group node[:user]
  mode '0600'
  content node[:secrets][:docker_registry_server_key]
end
file "#{node[:app_path]}/config/certs/server.crt" do
  owner node[:user]
  group node[:user]
  mode '0644'
  content node[:secrets][:docker_registry_server_crt]
end

# Register docker registry (and docker registry auth) service and start
template '/etc/systemd/system/docker-registry.service' do
  source 'templates/systemd/docker-registry.service'
  owner 'root'
  group 'root'
  mode  '0644'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

service 'docker-registry' do
  action [:enable, :start]
end
