require 'itamae/secrets'
require 'yaml'

module RecipeHelper
  def data_bag(name)
    Hashie::Mash.load(File.join(__dir__, 'data_bags', "#{name}.yml"))
  end
end
Itamae::Recipe::EvalContext.send(:include, RecipeHelper)

# TODO: load secret data by itamae secrets

execute "apt-get update" do
  action :nothing
end

execute "systemctl daemon-reload" do
  action :nothing
end

node['hosts'] = node['hosts'] || data_bag('hosts')
node['secrets'] = Itamae::Secrets(File.join(__dir__, 'secrets'))

node['roles'] = node['roles'] || []
node['roles'].each do |role|
  include_recipe "roles/#{role}/default.rb"
end
