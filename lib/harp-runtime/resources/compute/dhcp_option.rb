require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class DhcpOption < AvailableResource

      include Harp::Resources

      attribute :id,                          :aliases => 'dhcpOptionsId'
      attribute :dhcp_configuration_set,      :aliases => 'dhcpConfigurationSet'
      attribute :tag_set,                     :aliases => 'tagSet'
        
      attribute :description
      attribute :type
      attribute :live_resource
      attribute :state

      register_resource :dhcp_option, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::DhcpOption
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        dhcp_option = service.dhcp_options.create(create_attribs)
        @id = dhcp_option.id
        return dhcp_option
      end

      def destroy(service)
        if id
          dhcp_option = service.dhcp_options.destroy(id)
        else
          puts "No ID set, cannot delete."
        end
        return dhcp_option
      end

    end
  end
end
