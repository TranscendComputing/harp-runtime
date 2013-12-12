require 'set'
require 'fog/core/model'
require 'harp-runtime/models/elasticache'
require 'json'

module Harp
  module Resources

    class CacheSecurityGroupIngress < AvailableResource

      include Harp::Resources

        attribute :id
        attribute :group_name
		    attribute :name
        attribute :ec2_name
        attribute :ec2_owner_id
        attribute :description
        attribute :state
        attribute :type
        attribute :live_resource

        register_resource :cache_security_group_ingress, RESOURCES_ELASTICACHE

        # Only keeping a few properties, simplest define keeps.
        @keeps = /^id$|^name$/
        
        def keep(attribs)
          attribs[:id] = attribs[:name]
          super
        end

        def self.persistent_type()
        	::CacheSecurityGroupIngress
        end

        def create(service)
          cache_security_group_ingress = service.authorize_cache_security_group_ingress(group_name,ec2_name,ec2_owner_id)
          @id = cache_security_group_ingress.body['ResponseMetadata']['RequestId']
          return self
        end

        def destroy(service)
          if id
            #fog says this function is: to-do
            #cache_security_group_ingress = service.revoke_cache_security_group_ingress(group_name,ec2_name,ec2_owner_id)
          else
          	puts "No ID set, cannot delete."
        	end
        	return self
        end

    end
  end
end

