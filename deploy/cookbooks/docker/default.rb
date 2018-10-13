include_recipe "../apt_update"

package "apt-transport-https"
package "ca-certificates"
package "curl"
package "software-properties-common"

execute "add gpg key for package" do
  command "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
end

execute "add apt repository" do
  command 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
end

execute "apt update" do
  command "apt update"
end

package "docker"

service "docker" do
  action [:start, :enable]
end
