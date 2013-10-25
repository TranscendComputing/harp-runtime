require 'set'
require 'fog/core/model'
require 'harp-runtime/models/compute'

module Harp
  module Resources

    class ComputeInstance < AvailableResource

      include Harp::Resources
    
      attribute  :id,                       :aliases => 'instanceId'

      attr_accessor :architecture
      attribute :ami_launch_index,         :aliases => 'amiLaunchIndex'
      attribute :availability_zone,        :aliases => 'availabilityZone'
      attribute :block_device_mapping,     :aliases => 'blockDeviceMapping'
      attribute :network_interfaces,       :aliases => 'networkInterfaces'
      attribute :client_token,             :aliases => 'clientToken'
      attribute :dns_name,                 :aliases => 'dnsName'
      attribute :ebs_optimized,            :aliases => 'ebsOptimized'
      attribute :groups
      attribute :flavor_id,                :aliases => 'instanceType'
      attribute :hypervisor
      attribute :iam_instance_profile,     :aliases => 'iamInstanceProfile'
      attribute :image_id,                 :aliases => 'imageId'
      attribute :kernel_id,                :aliases => 'kernelId'
      attribute :key_name,                 :aliases => 'keyName'
      attribute :created_at,               :aliases => 'launchTime'
      attribute :lifecycle,                :aliases => 'instanceLifecycle'
      attribute :monitoring,               :squash =>  'state'
      attribute :placement_group,          :aliases => 'groupName'
      attribute :platform,                 :aliases => 'platform'
      attribute :product_codes,            :aliases => 'productCodes'
      attribute :private_dns_name,         :aliases => 'privateDnsName'
      attribute :private_ip_address,       :aliases => 'privateIpAddress'
      attribute :public_ip_address,        :aliases => 'ipAddress'
      attribute :ramdisk_id,               :aliases => 'ramdiskId'
      attribute :reason
      attribute :requester_id,             :aliases => 'requesterId'
      attribute :root_device_name,         :aliases => 'rootDeviceName'
      attribute :root_device_type,         :aliases => 'rootDeviceType'
      attribute :security_group_ids,       :aliases => 'securityGroupIds'
      attribute :source_dest_check,        :aliases => 'sourceDestCheck'
      attribute :spot_instance_request_id, :aliases => 'spotInstanceRequestId'
      attribute :state,                    :aliases => 'instanceState', :squash => 'name'
      attribute :state_reason,             :aliases => 'stateReason'
      attribute :subnet_id,                :aliases => 'subnetId'
      attribute :tenancy
      attribute :tags,                     :aliases => 'tagSet'
      attribute :user_data
      attribute :virtualization_type,      :aliases => 'virtualizationType'
      attribute :vpc_id,                   :aliases => 'vpcId'

      register_resource :compute_instance, RESOURCES_COMPUTE

      # Only keeping a few properties, simplest define keeps.
      @keeps = /key_name|^id$|^state$|^.*_ip_address/

      @output = true

      def self.persistent_type()
        ::ComputeInstance
      end

      def create(service)
        create_attribs = self.attribs
        tags = {"Name" => @name}
        create_attribs[:tags] = tags
        server = service.servers.create(create_attribs)
        @id = server.id
        return server
      end

      # Return a token to signify output from the current action
      def output_token(args={})
        if args[:action] == :create
          return "#{name}:#{@id}:#{key_name}"
        end
        if args[:action] == :destroy
          return "#{name}:#{@id}:#{key_name}"
        end
      end

      def get_output(service)
        server = service.servers.get_console_output(create_attribs)
      end


    end
  end
end