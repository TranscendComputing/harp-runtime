require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class NetworkInterface < AvailableResource

      include Harp::Resources

        attribute :id
        attribute :network_interface_id,        :aliases => 'networkInterfaceId'
        attribute :subnet_id,                   :aliases => 'subnetId'
        attribute :description,                 :aliases => 'description'
        attribute :status,                      :aliases => 'status'
        attribute :private_ip_address,          :aliases => 'privateIpAddress'
        attribute :source_dest_check,           :aliases => 'sourceDestCheck'
        attribute :group_set,                   :aliases => 'groupSet'
        attribute :tag_set,                     :aliases => 'tagSet'
        attribute :description
        attribute :type
        attribute :live_resource
        attribute :state



      register_resource :network_interface, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      # Return persistable attributes with only desired attributes to keep
      def keep(attribs)
        attribs[:id] = attribs[:network_interface_id]
        super
      end

      def self.persistent_type()
        ::NetworkInterface
      end


      def create(service)
        create_attribs = self.attribs[:attributes]
        network_interface = service.network_interfaces.create(create_attribs)
        @id = network_interface.network_interface_id
        return network_interface
      end

      def destroy(service)
        if id
          network_interface = service.network_interfaces.destroy(id)
        else
          raise "No ID set, cannot delete."
        end
        return network_interface
      end

    end
  end
end
