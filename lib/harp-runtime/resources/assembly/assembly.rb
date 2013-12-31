require 'set'
require 'fog/core/model'
require 'harp-runtime/models/assembly'
require 'harp-runtime/resources/compute/instance'
require 'json'

module Harp
  module Resources

    class Assembly < ComputeInstance

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
      
      # Return a token to signify output from the current action
      def output_token(args={})
        return "#{name}:#{id}"
      end

    end
  end
end
