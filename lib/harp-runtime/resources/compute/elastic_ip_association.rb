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
        attribute :public_ip
        
        attribute :description
        attribute :type
        attribute :live_resource
        attribute :state


      register_resource :elastic_ip_association, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/

      # Return persistable attributes with only desired attributes to keep 
      def keep(attribs)
        attribs[:id] = attribs[:association_id]
        super
      end

      def self.persistent_type()
        ::ElasticIPAssociation
      end


      def create(service)
        create_attribs = self.attribs[:attributes]
        address = service.associate_address(create_attribs[:server_id],create_attribs[:public_ip],nil,nil)
        #id = address.association_id
        return self
      end

      def destroy(service)
        public_ip = self.attribs[:attributes][:public_ip]
        if public_ip
          address = service.disassociate_address(public_ip)
        else
          puts "No ID set, cannot delete."
        end
        return address
      end

    end
  end
end
