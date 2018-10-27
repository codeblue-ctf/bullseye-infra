execute "download docker-compose" do
  command 'curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
  user 'root'
  not_if "test -e /usr/local/bin/docker-compose"
end

execute "install docker-compose" do
  command 'chmod +x /usr/local/bin/docker-compose'
  user 'root'
end
