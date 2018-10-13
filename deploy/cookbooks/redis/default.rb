include_recipe "../apt_update"

package "redis-server"

service "redis-server" do
  action [:start, :enable]
end
