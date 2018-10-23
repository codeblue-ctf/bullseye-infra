Admin.find_or_create_by(email: '<%= node[:admin][:username] %>') do |admin|
  admin.update(
    password: '<%= node[:admin][:password] %>'
  )
end
