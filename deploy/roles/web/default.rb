include_recipe "../../cookbooks/ruby"
include_recipe "../../cookbooks/redis"
include_recipe "../../cookbooks/mysql_server"

# Add environment to file
node[:env_file] = File.join(node[:app_path], '.env')
template node[:env_file] do
  source 'templates/environment'
  owner  node[:user]
  group  node[:user]
  mode   '644'
end

# create database
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


# setup bullseye web pplication
%w(ruby-dev gcc g++ libsqlite3-dev libmysqlclient-dev).each do |pkg|
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
execute 'systemctl daemon-reload' do
  action :nothing
end

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
