require 'set'
require 'fog/core/model'
require 'harp-runtime/models/autoscale'
require 'json'

module Harp
  module Resources

    class AutoScalingGroup < AvailableResource

      include Harp::Resources

        attribute :id,                        :aliases => 'AutoScalingGroupName'
        attribute :arn,                       :aliases => 'AutoScalingGroupARN'
        attribute :availability_zones,        :aliases => 'AvailabilityZones'
        attribute :created_at,                :aliases => 'CreatedTime'
        attribute :default_cooldown,          :aliases => 'DefaultCooldown'
        attribute :desired_capacity,          :aliases => 'DesiredCapacity'
        attribute :enabled_metrics,           :aliases => 'EnabledMetrics'
        attribute :health_check_grace_period, :aliases => 'HealthCheckGracePeriod'
        attribute :health_check_type,         :aliases => 'HealthCheckType'
        attribute :instances,                 :aliases => 'Instances'
        attribute :launch_configuration_name, :aliases => 'LaunchConfigurationName'
        attribute :load_balancer_names,       :aliases => 'LoadBalancerNames'
        attribute :max_size,                  :aliases => 'MaxSize'
        attribute :min_size,                  :aliases => 'MinSize'
        attribute :placement_group,           :aliases => 'PlacementGroup'
        attribute :suspended_processes,       :aliases => 'SuspendedProcesses'
        attribute :tags,                      :aliases => 'Tags'
        attribute :termination_policies,      :aliases => 'TerminationPolicies'
        attribute :vpc_zone_identifier,       :aliases => 'VPCZoneIdentifier'
        attribute :description
        attribute :type
        attribute :live_resource


        register_resource :auto_scaling_group, RESOURCES_AUTOSCALE

        # Only keeping a few properties, simplest define keeps.
        @keeps = /^id$/


        def self.persistent_type()
        	::AutoScalingGroup
        end

        def create(service)
            create_attribs=self.attribs[:attributes]
            group  = service.groups.create(create_attribs)
        	return group
        end

        def destroy(service)
        	if id
          	   group = service.groups.destroy(id)
        	else
          	   puts "No ID set, cannot delete."
        	end
        	return group
        end

    end
  end
end

