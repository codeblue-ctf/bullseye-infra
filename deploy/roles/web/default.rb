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
  db:seed
  assets:precompile
).each do |task|
  execute "rails #{task}" do
    user "#{node[:user]}"
    cwd "#{node[:app_path]}"
    command "bundle exec rails #{task}"
  end
end

# execute "rails server" do
#   user "#{node[:user]}"
#   cwd "#{node[:app_path]}"
#   command "bundle exec rails s"
# end