include_recipe "../../cookbooks/ruby"
include_recipe "../../cookbooks/redis"

package "ruby-dev"
package "gcc"
package "g++"
package "libsqlite3-dev"