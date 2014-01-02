require 'set'
require 'fog/core/model'
require 'harp-runtime/models/assembly'
require 'json'

module Harp
  module Resources

    # An Assembly is an operating system image combined with some bootstrapped
    # configuration.  For example, an Ubuntu image with a Chef client and an
    # initial Chef role can be saved as an assembly.
    class Assembly < AvailableResource

      include Harp::Resources

      identity  :id
      attribute :description
      attribute :live_resource
      attribute :state
      attribute :type

      attribute :name
      attribute :cloud
      attribute :configurations
      attribute :tool
      attribute :cloud_credential
      attribute :image

      attribute :config
      attribute :packages
      attribute :server_options

      register_resource :assembly, RESOURCES_ASSEMBLY

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::Assembly
      end

      def create(service)
        atts = self.attribs[:attributes]
        assembly = service.servers.create(atts[:server_options].symbolize_keys)
        assembly.wait_for { ready? }
        self.id = assembly.id
        provision_server(assembly.public_ip_address)
        return self
      end

      def destroy(service)
        if id
          destroy_provisioner(service.servers.get(id).private_dns_name)
          assembly = service.servers.destroy(id)
        else
          puts "No ID set, cannot delete."
        end
        return self
      end

    end
  end
end
