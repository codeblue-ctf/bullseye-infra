include_recipe "../apt_update"

# install ruby from package
package "ruby"

execute "install bundler" do
  command "gem install bundler"
end

# install ruby from rbenv
username = node[:rbenv][:username]
home_dir = node[:rbenv][:home_dir]
ruby_version = node[:rbenv][:ruby_version]

packages = %w(build-essential libssl-dev ruby rbenv)
packages.each do |pkg|
  package pkg do
    user 'root'
    action :install
  end
end

ruby_build_path = "#{home_dir}/.rbenv/plugins/ruby-build"
git ruby_build_path do
  user username
  repository 'https://github.com/rbenv/ruby-build'
end

execute 'install rbenv' do
  user username
  command <<-"EOS"
    echo 'export PATH="$HOME/.rbenv/shims:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  EOS
  not_if 'echo $PATH | grep rbenv'
end

execute "install ruby #{ruby_version}" do
  user username
  command <<-"EOS"
    rbenv install #{ruby_version}
    rbenv global #{ruby_version}
  EOS
  not_if "rbenv versions | grep #{ruby_version}"
end

