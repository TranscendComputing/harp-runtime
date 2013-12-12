require 'set'
require 'fog/core/model'
require 'harp-runtime/models/elasticache'
require 'json'

module Harp
  module Resources

    class CacheSecurityGroup < AvailableResource

      include Harp::Resources

        attribute :id, :aliases => 'CacheSecurityGroupName'
        attribute :description, :aliases => 'Description'
        attribute :ec2_groups, :aliases => 'EC2SecurityGroups', :type => :array
        attribute :owner_id, :aliases => 'OwnerId'
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

