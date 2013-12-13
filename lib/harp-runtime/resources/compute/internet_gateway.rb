require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class InternetGateway < AvailableResource

      include Harp::Resources

      attribute :id,                          :aliases => 'internetGatewayId'
      attribute :attachment_set,              :aliases => 'attachmentSet'
      attribute :tag_set,                     :aliases => 'tagSet'
        
      attribute :description
      attribute :type
      attribute :live_resource
      attribute :state

      register_resource :internet_gateway, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::InternetGateway
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        internet_gateway = service.internet_gateways.create
        @id = internet_gateway.id
        return internet_gateway
      end

      def destroy(service)
        if id
          internet_gateway = service.internet_gateways.destroy(id)
        else
          raise "No ID set, cannot delete."
        end
        return internet_gateway
      end

    end
  end
end
