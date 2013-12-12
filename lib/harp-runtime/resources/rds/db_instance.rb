require 'set'
require 'fog/core/model'
require 'harp-runtime/models/rds'

module Harp
  module Resources

    class DBInstance < AvailableResource

      include Harp::Resources

      attribute :id,                           :aliases => 'DBInstanceIdentifier'
      attribute :engine,                       :aliases => 'Engine'
      attribute :engine_version,               :aliases => 'EngineVersion'
      attribute :state,                        :aliases => 'DBInstanceStatus'
      attribute :allocated_storage,            :aliases => 'AllocatedStorage'
      attribute :availability_zone ,           :aliases => 'AvailabilityZone'
      attribute :flavor_id,                    :aliases => 'DBInstanceClass'
      attribute :endpoint,                     :aliases => 'Endpoint'
      attribute :read_replica_source,          :aliases => 'ReadReplicaSourceDBInstanceIdentifier'
      attribute :read_replica_identifiers,     :aliases => 'ReadReplicaDBInstanceIdentifiers'
      attribute :master_username,              :aliases => 'MasterUsername'
      attribute :multi_az,                     :aliases => 'MultiAZ'
      attribute :created_at,                   :aliases => 'InstanceCreateTime'
      attribute :last_restorable_time,         :aliases => 'LatestRestorableTime'
      attribute :auto_minor_version_upgrade,   :aliases => 'AutoMinorVersionUpgrade'
      attribute :pending_modified_values,      :aliases => 'PendingModifiedValues'
      attribute :preferred_backup_window,      :aliases => 'PreferredBackupWindow'
      attribute :preferred_maintenance_window, :aliases => 'PreferredMaintenanceWindow'
      attribute :db_name,                      :aliases => 'DBName'
      attribute :db_security_groups,           :aliases => 'DBSecurityGroups'
      attribute :db_parameter_groups,          :aliases => 'DBParameterGroups'
      attribute :backup_retention_period,      :aliases => 'BackupRetentionPeriod'
      attribute :license_model,                :aliases => 'LicenseModel'
      attribute :db_subnet_group_name,         :aliases => 'DBSubnetGroupName'
      attribute :publicly_accessible,          :aliases => 'PubliclyAccessible'
      attribute :vpc_security_groups,          :aliases => 'VpcSecurityGroups'
      attribute :password
      
      attribute :description
      attribute :type
      attribute :live_resource

      attr_accessor :parameter_group_name, :security_group_names, :port

      register_resource :db_instance, RESOURCES_RDS

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$|^name$/
      
      @output = false

      def self.persistent_type()
        ::DBInstance
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        create_attribs[:tags] = {"Name" => @name}
        create_attribs[:id] = @name
        instance = service.servers.create(create_attribs)
        @id = instance.id
        return instance
      end
      
      def destroy(service)
        if id
          instance = service.servers.destroy(id)
        else
          raise "No ID set, cannot delete."
        end
        return instance
      end

    end
  end
end
