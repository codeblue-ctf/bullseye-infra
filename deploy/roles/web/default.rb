node.reverse_merge!(
  mysql_server: {
    username: 'web',
    database: 'bullseye_production',
    password: node[:secrets][:web_db_password]
  },
  admin: {
    username: 'admin',
    password: node[:secrets][:web_admin_password]
  },
  rbenv: {
    username: 'ubuntu',
    home_dir: '/home/ubuntu',
    ruby_version: '2.6.4'
  }
)

include_recipe "../../cookbooks/deploy_key"
include_recipe "../../cookbooks/known_hosts"
include_recipe "../../cookbooks/ruby"
include_recipe "../../cookbooks/mysql_server"

# Clone bullseye web
unless node[:is_vagrant] then
  git node[:app_path] do
    repository 'git@gitlab.com:CBCTF/bullseye-web.git'
    user node[:user]
  end
end

# Add environment to file
node[:env_file] = File.join(node[:app_path], '.env')
template node[:env_file] do
  source 'templates/environment'
  owner  node[:user]
  group  node[:user]
  mode   '644'
end

# Create database
execute 'create database' do
  user 'root'
  command "mysql -u root -e \"create database #{Shellwords.escape(node[:mysql_server][:database])}\""
  not_if "mysql -u root -e \"show databases\" | grep #{Shellwords.escape(node[:mysql_server][:database])}"
end

execute 'grant privileges' do
  user 'root'
  command "mysql -u root -e \"grant all privileges on #{Shellwords.escape(node[:mysql_server][:database])}.* to #{node[:mysql_server][:username]}@localhost \""
  not_if "mysql -u root -e \"show grants for #{node[:mysql_server][:username]}@localhost\" | grep #{Shellwords.escape(node[:mysql_server][:database])}"
end

# Setup bullseye web application
file "#{node[:app_path]}/config/master.key" do
  owner node[:user]
  group node[:user]
  mode '0600'
  content node[:secrets][:web_master_key]
end

# install yarn
execute 'install yarn' do
  user 'root'
  command <<-"EOS"
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    apt update
  EOS
  not_if 'which yarn'
end

%w(ruby-dev gcc g++ libsqlite3-dev libmysqlclient-dev libxml2-dev yarn).each do |pkg|
  package pkg
end

execute "bundle install" do
  user "#{node[:user]}"
  cwd "#{node[:app_path]}"
  command "RAILS_ENV=production rbenv exec bundle install --path=vendor/bundle"
end

template "#{node[:app_path]}/db/seeds/production.rb" do
  source 'templates/seeds/production.rb'
  owner  node[:user]
  group  node[:user]
  mode   '644'
end

%w(
  db:migrate
  db:seed
  assets:precompile
).each do |task|
  execute "rails #{task}" do
    user "#{node[:user]}"
    cwd "#{node[:app_path]}"
    command "RAILS_ENV=production rbenv exec bundle exec rails #{task}"
  end
end

# Register bullseye web service
template '/etc/systemd/system/bullseye-web.service' do
  source 'templates/systemd/bullseye-web.service'
  owner 'root'
  group 'root'
  mode  '0644'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

service 'bullseye-web' do
  action [:enable, :start]
end

# XXX: runner-masterから結果を定期的に取得するやつ
template '/etc/systemd/system/bullseye-web-worker.service' do
  source 'templates/systemd/bullseye-web-worker.service'
  owner 'root'
  group 'root'
  mode  '0644'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

service 'bullseye-web-worker' do
  action [:enable, :start]
end

# Start nginx
package 'nginx'
service 'nginx' do
  action [:enable, :start]
end

# Place certificates
file "/etc/nginx/server.key" do
  owner node[:user]
  group node[:user]
  mode '0600'
  content node[:secrets][:docker_registry_server_key] # XXX: using same secret key with docker registry
end
file "/etc/nginx/server.crt" do
  owner node[:user]
  group node[:user]
  mode '0644'
  content node[:secrets][:docker_registry_server_crt] # XXX: using same secret key with docker registry
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
  notifies :reload, 'service[nginx]'
end
template '/etc/nginx/sites-enabled/bullseye-web' do
  source 'templates/nginx/bullseye-web'
  owner  'root'
  group  'root'
  mode   '644'
  notifies :reload, 'service[nginx]'
end
