# TODO: load secret data by itamae secrets

execute "apt-get update" do
  action :nothing
end

execute "systemctl daemon-reload" do
  action :nothing
end

node['roles'] = node['roles'] || []
node['roles'].each do |role|
  include_recipe "roles/#{role}/default.rb"
end
