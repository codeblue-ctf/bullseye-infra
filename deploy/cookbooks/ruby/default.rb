include_recipe "../apt_update"

package "ruby"
package "ruby-dev"
package "gcc"

execute "install bundler" do
  command "gem install bundler"
end
