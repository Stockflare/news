# Isolates the Shotgun::Services class behind a domain-specific namespace.
#
# @note All micro-services should be accessed through this namespace.
class Services < Shotgun::Services
end

puts Services::News::Posts.new(:posts).get.response.first.title.inspect
