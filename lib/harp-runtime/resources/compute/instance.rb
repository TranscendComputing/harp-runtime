require 'set'
require 'fog/core/model'

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

      def create(service)
        service.servers.create(self.attribs)
      end

    end
  end
end