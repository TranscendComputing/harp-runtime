require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class RouteTable < AvailableResource

      include Harp::Resources

      attribute :id,               :aliases => 'routeTableId'
      attribute :vpc_id,           :aliases => 'vpcId'
      attribute :routes,           :aliases => 'routeSet'
      attribute :associations,     :aliases => 'associationSet'
      attribute :tags,             :aliases => 'tagSet'
        
      attribute :description
      attribute :type
      attribute :live_resource
      attribute :state

      register_resource :route_table, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::RouteTable
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        route_table = service.route_tables.create(create_attribs)
        @id = route_table.id
        return route_table
      end

      def destroy(service)
        if id
          route_table = service.route_tables.destroy(id)
        else
          puts "No ID set, cannot delete."
        end
        return route_table
      end

    end
  end
end
