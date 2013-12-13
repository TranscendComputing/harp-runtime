require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class ElasticIP < AvailableResource

      include Harp::Resources

        attribute :id
        attribute :public_ip_address
        attribute :public_ip,                  :aliases => 'publicIp'
        attribute :server_id,                  :aliases => 'instanceId'
        attribute :domain
        
        attribute :description
        attribute :type
        attribute :live_resource
        attribute :state

      register_resource :elastic_ip, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$|public_ip_address/

      # Return persistable attributes with only desired attributes to keep 
      def keep(attribs)
        attribs[:public_ip_address] = attribs[:public_ip]
        attribs[:id] = attribs[:public_ip]
        super
      end


      def self.persistent_type()
        ::ElasticIP
      end


      def create(service)
        create_attribs = self.attribs
        address = service.addresses.create(create_attribs)
        @id = address.public_ip
        return address
      end

      def destroy(service)
        if id
          address = service.addresses.destroy(id)
        else
          raise "No ID set, cannot delete."
        end
        return address
      end

    end
  end
end
