require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class Route < AvailableResource

      include Harp::Resources

      attribute :id
      attribute :route_table_id
      attribute :destination_cidr_block
      
      attribute :destination_cidr_block
      attribute :internet_gateway_id
      attribute :instance_id
      attribute :network_interface_id
      
      attribute :description
      attribute :type
      attribute :live_resource
      attribute :state

      register_resource :route, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::Route
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        route = service.create_route(create_attribs[:route_table_id],create_attribs[:destination_cidr_block],create_attribs[:internet_gateway_id],create_attribs[:instance_id],create_attribs[:network_interface_id])
        @id = route.body['requestId']
        return self
      end

      def destroy(service)
        if route_table_id && destination_cidr_block
          route = service.delete_route(route_table_id,destination_cidr_block)
        else
          puts "No ID set, cannot delete."
        end
        return self
      end

    end
  end
end
