require 'set'

require 'harp-runtime/resources/compute/instance'
require 'harp-runtime/resources/compute/security_group'

module Harp
  module Resources
    extend self

    def Resources.included(base)
      puts "Adding #{self},#{base} as a resource"
    end

    def self.method_added(method_name)
      Logging.logger[self].debug "Adding #{method_name.inspect}"
    end

  end
end

