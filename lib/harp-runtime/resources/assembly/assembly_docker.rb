require 'set'
require 'fog/core/model'
require 'harp-runtime/models/assembly'
require 'harp-runtime/resources/assembly/assembly'
require 'json'

module Harp
  module Resources

    class AssemblyDocker < Assembly

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

      attribute :packages
      attribute :server_options

      register_resource :assembly_docker, RESOURCES_ASSEMBLY

      # Only keeping a few properties, simplest define keeps.
      # this is a change I'm making in sublime.

      @keeps = /^id$/

      def self.persistent_type()
        ::AssemblyDocker
      end

      def provision_server(server_ip)
      end

      def destroy_provisioner(private_dns_name)
      end

    end
  end
end
