include_recipe "../../cookbooks/ruby"
include_recipe "../../cookbooks/redis"

package "ruby-dev"
package "gcc"
package "g++"
package "libsqlite3-dev"

execute "bundle install" do
  user "#{node[:user]}"
  cwd "#{node[:app_path]}"
  command "bundle install --path=vendor/bundle"
end

%w(
  db:migrate
  assets:precompile
).each do |task|
  execute "rails #{task}" do
    user "#{node[:user]}"
    cwd "#{node[:app_path]}"
    command "bundle exec rails #{task}"
  end
end

execute 'systemctl daemon-reload' do
  action :nothing
end

template '/etc/systemd/system/bullseye-web.service' do
  source 'templates/bullseye-web.service'
  owner 'root'
  group 'root'
  mode  '0644'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

service 'bullseye-web' do
  action [:enable, :start]
end
