require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class DhcpOptionAssociation < AvailableResource

      include Harp::Resources

      attribute :id
      attribute :dhcp_options_id
      attribute :vpc_id
      
      attribute :description
      attribute :type
      attribute :live_resource
      attribute :state

      register_resource :dhcp_option_association, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::DhcpOptionAssociation
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        dhcp_option_association = service.associate_dhcp_options(create_attribs[:dhcp_options_id], create_attribs[:vpc_id])
        @id = dhcp_option_association.body['requestId']
        return self
      end

      def destroy(service)
        require 'pry'
        binding.pry
        if dhcp_options_id
          dhcp_option_association = service.dhcp_options.destroy(dhcp_options_id)
        else
          puts "No ID set, cannot delete."
        end
        return self
      end

    end
  end
end
