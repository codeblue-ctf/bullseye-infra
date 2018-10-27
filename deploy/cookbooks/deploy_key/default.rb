file "/home/#{node[:user]}/.ssh/id_rsa" do
  owner node[:user]
  group node[:user]
  mode '0600'
  content node[:secrets][:deploy_key_private]
end
