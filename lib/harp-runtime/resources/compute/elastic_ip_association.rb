require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class ElasticIPAssociation < AvailableResource

      include Harp::Resources

        attribute :id,                         :aliases => 'associationId'
        attribute :allocation_id,              :aliases => 'allocationId'
        attribute :server_id,                  :aliases => 'instanceId'
        attribute :network_interface_id,       :aliases => 'networkInterfaceId'
        attribute :network_interface_owner_id, :aliases => 'networkInterfaceOwnerId'


      register_resource :elastic_ip_association, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/

      def self.persistent_type()
        ::ElasticIPAssociation
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
