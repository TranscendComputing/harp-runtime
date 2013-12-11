require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'

module Harp
  module Resources

    class SecurityGroupIngress < AvailableResource

      include Harp::Resources

      attribute :id
      attribute :group_name
      attribute :options
      
      attribute :description
      attribute :type
      attribute :live_resource
      attribute :state

      register_resource :security_group_ingress, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/
      
      @output = false

      def self.persistent_type()
        ::SecurityGroupIngress
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        security_group_ingress = service.authorize_security_group_ingress(create_attribs[:group_name],create_attribs[:options])
        @id = security_group_ingress.body['requestId']
        return self
      end
      
      def destroy(service)
        if group_name && options
          security_group_ingress = service.revoke_security_group_ingress(group_name,options)
        else
          puts "No ID set, cannot delete."
        end
        return self
      end

    end
  end
end