Admin.find_or_create_by(login_name: '<%= node[:admin][:username] %>') do |admin|
  admin.update(
    password: '<%= node[:admin][:password] %>'
  )
end
