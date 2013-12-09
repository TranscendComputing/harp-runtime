require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'
require 'json'

module Harp
  module Resources

    class Volume < AvailableResource

      include Harp::Resources

        identity  :id,                    :aliases => 'volumeId'
        attribute :attached_at,           :aliases => 'attachTime'
        attribute :availability_zone,     :aliases => 'availabilityZone'
        attribute :created_at,            :aliases => 'createTime'
        attribute :delete_on_termination, :aliases => 'deleteOnTermination'
        attribute :device
        attribute :iops
        attribute :server_id,             :aliases => 'instanceId'
        attribute :size
        attribute :snapshot_id,           :aliases => 'snapshotId'
        attribute :state,                 :aliases => 'status'
        attribute :tags,                  :aliases => 'tagSet'
        attribute :type,                  :aliases => 'volumeType'

      register_resource :volume, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/


      def self.persistent_type()
        ::Volume
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        volume = service.volumes.create(create_attribs)
        return volume
      end

      def destroy(service)
        if id
          volume = service.volumes.destroy(id)
        else
          puts "No ID set, cannot delete."
        end
        return volume
      end

    end
  end
end
