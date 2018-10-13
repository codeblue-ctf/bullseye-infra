include_recipe "../apt_update"

package "ruby"

execute "install bundler" do
  command "gem install bundler"
end
