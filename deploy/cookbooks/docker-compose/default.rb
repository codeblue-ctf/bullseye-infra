execute "download docker-compose" do
  command 'sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
end

execute "install docker-compose" do
  command "sudo chmod +x /usr/local/bin/docker-compose"
end