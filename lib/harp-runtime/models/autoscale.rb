require 'data_mapper'
require 'harp-runtime/models/base'

# AutoScalingGroup is the datastore representation of an auto scaling group.
class AutoScalingGroup < HarpResource
end

# AutoScalingGroup is the datastore representation of a launch configuration,
# used by an auto scaling group to create new instances.
class LaunchConfiguration < HarpResource
end

# AutoScalingGroup is the datastore representation of scaling rules for a group.
class ScalingPolicy < HarpResource
end
