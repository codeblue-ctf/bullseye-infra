node.reverse_merge!(
  mysql_server: {
    username: 'web',
    database: 'bullseye_production',
    password: node[:secrets][:web_db_password]
  },
  admin: {
    username: 'admin@codeblue.jp',
    password: node[:secrets][:web_admin_password]
  }
)

include_recipe "../../cookbooks/deploy_key"
include_recipe "../../cookbooks/known_hosts"
include_recipe "../../cookbooks/ruby"
include_recipe "../../cookbooks/redis"
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

# Setup bullseye web pplication
file "#{node[:app_path]}/config/master.key" do
  owner node[:user]
  group node[:user]
  mode '0600'
  content node[:secrets][:web_master_key]
end

%w(ruby-dev gcc g++ libsqlite3-dev libmysqlclient-dev libxml2-dev).each do |pkg|
  package pkg
end

execute "bundle install" do
  user "#{node[:user]}"
  cwd "#{node[:app_path]}"
  command "RAILS_ENV=production bundle install --path=vendor/bundle"
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
    command "RAILS_ENV=production bundle exec rails #{task}"
  end
end

# register bullseye web service
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

# register bullseye web worker service
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

# start nginx

package 'nginx'
service 'nginx' do
  action [:enable, :start]
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
