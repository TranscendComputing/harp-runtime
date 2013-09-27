require 'set'
require 'fog/core/model'

module Harp
  module Resources

    class SecurityGroup < AvailableResource

      include Harp::Resources

      identity  :name,            :aliases => 'groupName'
      attribute :description,     :aliases => 'groupDescription'
      attribute :group_id,        :aliases => 'groupId'
      attribute :ip_permissions,  :aliases => 'ipPermissions'
      attribute :ip_permissions_egress,  :aliases => 'ipPermissionsEgress'
      attribute :owner_id,        :aliases => 'ownerId'
      attribute :vpc_id,          :aliases => 'vpcId'

      register_resource :security_group, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /name|description/

      def self.persistent_type()
        ::SecurityGroup
      end

      def create(service)
        service.security_groups.new(self.attribs)
      end

    end
  end
end