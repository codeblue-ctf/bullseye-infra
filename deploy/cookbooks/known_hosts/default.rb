node.reverse_merge!(
  known_hosts: ['gitlab.com', 'github.com']
)

known_hosts_file = "/home/#{node[:user]}/.ssh/known_hosts"

execute "create known_hosts" do
  user node[:user]
  command "ssh-keyscan -H #{node[:known_hosts].join(' ')} >> #{known_hosts_file}"
  not_if "test -e #{known_hosts_file}"
end
