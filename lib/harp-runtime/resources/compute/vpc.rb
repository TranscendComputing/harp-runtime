require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class Vpc < AvailableResource

      include Harp::Resources

      attribute :id,                :aliases => 'vpcId'

      attribute :state
      attribute :cidr_block,       :aliases => 'cidrBlock'
      attribute :dhcp_options_id,  :aliases => 'dhcpOptionsId'
      attribute :tags,             :aliases => 'tagSet'
      attribute :tenancy,          :aliases => 'instanceTenancy'
        
      attribute :description
      attribute :type
      attribute :live_resource

      register_resource :vpc, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::Vpc
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        vpc = service.vpcs.create(create_attribs)
        @id = vpc.id
        return vpc
      end

      def destroy(service)
        if id
          vpc = service.vpcs.destroy(id)
        else
          raise "No ID set, cannot delete."
        end
        return vpc
      end

    end
  end
end
