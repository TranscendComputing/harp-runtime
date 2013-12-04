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
        attribute :allocation_id,              :aliases => 'allocationId'
        attribute :association_id,             :aliases => 'associationId'
        attribute :server_id,                  :aliases => 'instanceId'
        attribute :network_interface_id,       :aliases => 'networkInterfaceId'
        attribute :network_interface_owner_id, :aliases => 'networkInterfaceOwnerId'
        attribute :domain

      register_resource :elastic_ip, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$|public_ip_address/

      # Return persistable attributes with only desired attributes to keep 
      def keep(attribs)
        attribs[:public_ip_address] = attribs[:public_ip]
        super
      end

      def self.persistent_type()
        ::ElasticIP
      end


      def create(service)
        create_attribs = self.attribs
        address = service.addresses.create(create_attribs)
        @id = SecureRandom.urlsafe_base64(16)
        return address
      end

      def destroy(service)
        destroy_attribs = self.attribs
        if @id
          address = service.addresses.destroy(destroy_attribs)
        else
          puts "No ID set, cannot delete."
        end
        return address
      end

    end
  end
end
