include_recipe "../apt_update"

package "ruby"
package "ruby-dev"

execute "install bundler" do
  command "gem install bundler"
end
