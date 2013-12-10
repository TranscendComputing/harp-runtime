require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class Subnet < AvailableResource

      include Harp::Resources

        attribute :id
        attribute :subnet_id,                   :aliases => 'subnetId'
        attribute :vpc_id,                      :aliases => 'vpcId'
        attribute :cidr_block,                  :aliases => 'cidrBlock'
        attribute :available_ip_address_count,  :aliases => 'availableIpAddressCount'
        attribute :availability_zone,           :aliases => 'availabilityZone'
        attribute :tag_set,                     :aliases => 'tagSet'
        attribute :description
        attribute :type
        attribute :live_resource
        attribute :state



      register_resource :subnet, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      # Return persistable attributes with only desired attributes to keep 
      def keep(attribs)
        attribs[:id] = attribs[:subnet_id]
        super
      end

      def self.persistent_type()
        ::Subnet
      end


      def create(service)
        create_attribs = self.attribs[:attributes]
        subnet = service.subnets.create(create_attribs)
        @id = subnet.subnet_id
        return subnet
      end

      def destroy(service)
        if id
          subnet = service.subnets.destroy(id)
        else
          puts "No ID set, cannot delete."
        end
        return subnet
      end

    end
  end
end
