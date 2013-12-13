require 'set'
require 'fog/core/model'
require 'harp-runtime/models/autoscale'
require 'json'

module Harp
  module Resources

    class ScalingPolicy < AvailableResource

      include Harp::Resources

      identity  :id,                       :aliases => 'PolicyName'
      attribute :arn,                     :aliases => 'PolicyARN'
      attribute :adjustment_type,         :aliases => 'AdjustmentType'
      attribute :alarms,                  :aliases => 'Alarms'
      attribute :auto_scaling_group_name, :aliases => 'AutoScalingGroupName'
      attribute :cooldown,                :aliases => 'Cooldown'
      attribute :min_adjustment_step,     :aliases => 'MinAdjustmentStep'
      attribute :scaling_adjustment,      :aliases => 'ScalingAdjustment'
      attribute :description
      attribute :state
      attribute :type
      attribute :live_resource

      register_resource :scaling_policy, RESOURCES_AUTOSCALE

        # Only keeping a few properties, simplest define keeps.
        @keeps = /^id$/


        def self.persistent_type()
          ::ScalingPolicy
        end

        def create(service)
          create_attribs=self.attribs[:attributes]
          policy  = service.policies.create(create_attribs)
          return policy
        end

        def destroy(service)
          if id
            policy = service.delete_policy(auto_scaling_group_name, id)
          else
            raise "No ID set, cannot delete."
          end
          return policy
        end

      end
    end
  end

