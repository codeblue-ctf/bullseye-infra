username = node[:mysql_server][:username]
password = node[:mysql_server][:password]

package 'mysql-server'

service 'mysql' do
  action [:start, :enable]
end

execute 'initialize mysql' do
  user 'root'
  command "mysql -u root -e \"create user #{Shellwords.escape(username)}@localhost identified by '#{Shellwords.escape(password)}'\""
  not_if "mysql -u root -e \"select authentication_string from mysql.user where user = '#{Shellwords.escape(username)}'\" | grep -v authentication_string"
end
