require 'set'
require 'fog/core/model'
require 'harp-runtime/models/rds'

module Harp
  module Resources

    class DBSecurityGroup < AvailableResource

      include Harp::Resources

      attribute  :id,                   :aliases => 'DBSecurityGroupName'
      attribute  :description,          :aliases => 'DBSecurityGroupDescription'
      attribute  :ec2_security_groups,  :aliases => 'EC2SecurityGroups'
      attribute  :ip_ranges,            :aliases => 'IPRanges'
      attribute  :owner_id,             :aliases => 'OwnerId'

      register_resource :db_security_group, RESOURCES_RDS

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$|description/
      
      @output = false

      def self.persistent_type()
        ::DBSecurityGroup
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        create_attribs[:tags] = {"Name" => @name}
        create_attribs[:id] = @name
        security_group = service.security_groups.create(create_attribs)
        @id = security_group.id
        return security_group
      end
      
      def destroy(service)
        destroy_attribs = self.attribs
        if @id
          security_group = service.security_groups.destroy(destroy_attribs)
        else
          puts "No ID set, cannot delete."
        end
        return security_group
      end

    end
  end
end