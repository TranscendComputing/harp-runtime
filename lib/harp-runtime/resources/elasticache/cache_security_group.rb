require 'set'
require 'fog/core/model'
require 'harp-runtime/models/autoscale'
require 'json'

module Harp
  module Resources

    class CacheSecurityGroup < AvailableResource

      include Harp::Resources

        identity  :id,              :aliases => 'cacheSecurityGroupName'
        attribute :description,     :aliases => 'description'
        attribute :state
        attribute :type
        attribute :live_resource

        register_resource :cache_security_group, RESOURCES_ELASTICACHE

        # Only keeping a few properties, simplest define keeps.
        @keeps = /^id$/


        def self.persistent_type()
        	::CacheSecurityGroup
        end

        def create(service)
            create_attribs=self.attribs[:attributes]
            security_group  = service.security_groups.create(create_attribs)
        	return security_group
        end

        def destroy(service)
        	if id
               security_group = service.security_groups.destroy(id)
        	else
          	   puts "No ID set, cannot delete."
        	end
        	return security_group
        end

    end
  end
end

