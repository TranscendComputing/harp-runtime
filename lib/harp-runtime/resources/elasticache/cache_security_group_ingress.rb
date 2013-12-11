require 'set'
require 'fog/core/model'
require 'harp-runtime/models/autoscale'
require 'json'

module Harp
  module Resources

    class CacheSecurityGroupIngress < AvailableResource

      include Harp::Resources

        identity  :id, 					:aliases => 'cacheSecurityGroupName'
		attribute :ec2_groups, 			:aliases => 'ec2SecurityGroups', :type => :array
        attribute :owner_id, 			:aliases => 'ownerId'
        attribute :description
        attribute :state
        attribute :type
        attribute :live_resource

        register_resource :cache_security_group_ingress, RESOURCES_ELASTICACHE

        # Only keeping a few properties, simplest define keeps.
        @keeps = /^id$/


        def self.persistent_type()
        	::CacheSecurityGroupIngress
        end

        def create(service)
            security_group  = service.authorize_ec2_group(CacheSecurityGroupName, OwnerId)
        	return security_group
        end

        def destroy(service)
        	if id
               security_group = service.revoke_ec2_group(id, OwnerId)
        	else
          	   puts "No ID set, cannot delete."
        	end
        	return security_group
        end

    end
  end
end

