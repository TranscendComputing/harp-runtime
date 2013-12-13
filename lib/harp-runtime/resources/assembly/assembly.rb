require 'set'
require 'fog/core/model'
require 'harp-runtime/models/assembly'
require 'json'

module Harp
  module Resources

    class Assembly < AvailableResource

      include Harp::Resources

      identity  :id
      attribute :description
      attribute :live_resource
      attribute :state
      
      attribute :name
      attribute :cloud
      attribute :configurations
      attribute :tool
      attribute :cloud_credential
      attribute :image
      
      attribute :packages
      attribute :server_options

      register_resource :assembly, RESOURCES_ASSEMBLY

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::Assembly
      end

      def create(service)
        server_options = self.attribs[:attributes][:server_options]
        assembly = service.servers.create(server_options)
        self.id = assembly.id
        return self
      end

      def destroy(service)
        if id
          assembly = service.servers.destroy(id)
        else
          puts "No ID set, cannot delete."
        end
        return self
      end

    end
  end
end
