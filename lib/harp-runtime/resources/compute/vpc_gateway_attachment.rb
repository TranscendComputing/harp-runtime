require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class VpcGatewayAttachment < AvailableResource

      include Harp::Resources

      attribute :id
      attribute :internet_gateway_id
      attribute :vpc_id
      
      attribute :description
      attribute :type
      attribute :live_resource
      attribute :state

      register_resource :vpc_gateway_attachment, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::VpcGatewayAttachment
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        vpc_gateway_attachment = service.attach_internet_gateway(create_attribs[:internet_gateway_id], create_attribs[:vpc_id])
        self.id = vpc_gateway_attachment.body['requestId']
        return self
      end

      def destroy(service)
        if internet_gateway_id && vpc_id
          vpc_gateway_attachment = service.detach_internet_gateway(internet_gateway_id, vpc_id)
        else
          raise "No ID set, cannot delete."
        end
        return self
      end

    end
  end
end
