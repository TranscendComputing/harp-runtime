require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'

module Harp
  module Resources

    class SecurityGroup < AvailableResource

      include Harp::Resources

      attribute :id,              :aliases => 'groupId'
      attribute :name,            :aliases => 'groupName'
      attribute :description,     :aliases => 'groupDescription'
      attribute :ip_permissions,  :aliases => 'ipPermissions'
      attribute :ip_permissions_egress,  :aliases => 'ipPermissionsEgress'
      attribute :owner_id,        :aliases => 'ownerId'
      attribute :vpc_id,          :aliases => 'vpcId'
      
      attribute :type
      attribute :live_resource
      attribute :state

      register_resource :security_group, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$|name|description/
      
      # Return persistable attributes with only desired attributes to keep 
      def keep(persist_attribs)
        persist_attribs[:id] = persist_attribs[:group_id]
        super
      end
      
      @output = false

      def self.persistent_type()
        ::SecurityGroup
      end

      def create(service)
        create_attribs = self.attribs
        #security_group = service.security_groups.new(self.attribs)
        tags = {"Name" => @name}
        create_attribs[:tags] = tags
        security_group = service.security_groups.create(create_attribs[:attributes])
        @id = security_group.group_id
        return security_group
      end
      
      def destroy(service)
        if id
          security_groups = service.security_groups.destroy(name)
        else
          raise "No ID set, cannot delete."
        end
        return security_groups
      end

    end
  end
end
