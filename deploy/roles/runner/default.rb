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

execute "npm install" do
  user node[:user]
  cwd node[:app_path]
  command "npm install"
end

# Register bullseye runner service and start
template '/etc/systemd/system/bullseye-runner.service' do
  source 'templates/systemd/bullseye-runner.service'
  owner 'root'
  group 'root'
  mode  '0644'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

service 'bullseye-runner' do
  action [:enable, :start]
end
