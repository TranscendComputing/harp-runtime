# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2

require 'set'

module Harp
  module Resources
    AUTOSCALE_GROUP = :autoScaleGroup
    LAUNCH_CONFIGURATION = :launchConfiguration
    COMPUTE_INSTANCE = "Std::computeInstance"
    AUTOSCALE_POLICY = :autoScalePolicy

    RESOURCES_AUTOSCALE = Set.new [ AUTOSCALE_GROUP, LAUNCH_CONFIGURATION  ]

    RESOURCES_COMPUTE = Set.new [ COMPUTE_INSTANCE  ]
  end
end

__END__
Other types to be defined:
Auto Scaling Policy
Auto Scaling Trigger
Alarm
Compute External Gateway
Compute EC2 DHCP Options
Compute Elastic IP Address
Compute Elastic IP Address Association
Compute Instance
Compute Internet Gateway
Compute Network ACL
Compute Network ACL Entry
Compute NetworkInterface
Compute Route
Compute Route Table
Compute Security Group
Compute Security Group Ingress
Compute Security Group Egress
Compute Subnet
Compute Subnet Network ACL Association
Compute Subnet Route Table Association
Compute Volume
Compute Volume Attachment
Compute VPC
Compute VPC Dhcp Options Association
Compute VPC Gateway Attachment
Compute VPN Connection
Compute VPN Gateway
Cache Cache Cluster
Cache Parameter Group
Cache Security Group
Cache Security Group Ingress
Elastic Application
Elastic Environment
Load Balancer
Identity Access Key
Identity Group
Identity Instance Profile
Identity Policy
Identity Role
Identity Add User to Group
Identity User
Relational Database DBInstance
Relational Database DB Subnet Group
Relational Database DBSecurityGroup
Relational Database Security Group Ingress
DNS Resource Record Set
DNS Resource Record Set Group
Storage Bucket
Storage Bucket Policy
KeyValue DB Domain
Notification Service TopicPolicy
Notification Service Topic
Queue Service Queue
Queue Service Queue Policy

Presence (Global locations, failover)
Environment (Dev, Test, Stage, ...)
Stack (Set of related resources)
Tier (Application Tier or Layer)
