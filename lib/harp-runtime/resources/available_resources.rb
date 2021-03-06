# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2

require 'set'
require 'fog/core/model'

module Harp
  module Resources

    # Set to contain all resources for auto scale
    RESOURCES_AUTOSCALE = Set.new

    # Set to contain all beanstalk resources
    RESOURCES_BEANSTALK = Set.new

    # Set to contain all compute resources
    RESOURCES_COMPUTE = Set.new

    # Set to contain all elasticache resources
    RESOURCES_ELASTICACHE = Set.new

    # Set to contain all load_balancing resources
    RESOURCES_ELASTIC_LOAD_BALANCING = Set.new

    # Set to contain all rds resources
    RESOURCES_RDS = Set.new
    
    # Set to contain all assembly resources
    RESOURCES_ASSEMBLY = Set.new

    # The set of sets
    RESOURCE_SETS = Set.new

    class AvailableResource < Fog::Model

      class << self
        attr_accessor :keeps
        attr_accessor :prunes
      end

      attr_accessor :name
      @name = nil
      @keeps = nil
      @prunes = nil
      @output = false

      @@logger = Logging.logger[self]
      @@subclasses = { }
      @@service = { }

      DESTROYED = "DESTROYED"
      CREATED = "CREATED"

      def self.create type
        cs = @@subclasses[type]
        if cs
          cs.new
        else
          raise "Bad resource type: #{type}"
        end
      end

      # Subclasses call to categorize themselves by service (compute, dns, etc.)
      # and to register as the JSON type to which they respond.
      def self.register_resource name, service
        @@subclasses[name] = self
        @@logger.debug "Adding #{self} as a resource #{name}"
        if ! service.nil?
          service.add(self)
          RESOURCE_SETS.add(service)
        end
      end

      # Build the subclass by the JSON type supplied as input.
      def self.from_name name
        std_resource = name [/^Std::(\w+)/, 1]
        if std_resource
          @@logger.debug "Create class of type: #{std_resource.underscore}"
          create std_resource.underscore.to_sym
        end
      end

      # Flesh out this resource's instance variables from supplied JSON.
      def populate resource
        resource.each { |name,value|
          if ! ["type",:output_token,:value,:harp_script_id].include?(name)
            if self.class.aliases.include?(name)
              aliased = self.class.aliases[name]
              @@logger.debug "Setting var: #{aliased} to #{value}"
              send("#{aliased}=", value)
            else
              @@logger.debug "Setting var: #{name} to #{value}"
              send("#{name}=", value)
            end
          end
        }
      end

      # Extract attributes into a hash of variables to supply to engine.
      def attribs
        hash = self.instance_variables.each_with_object({}) { |var,hash|
          hash[var.to_s[1..-1].to_sym] = self.instance_variable_get(var)
        }
        hash.delete(:service)
        hash
      end

      # Return persistable attributes with only desired attributes to keep
      def keep(persist_attribs)
        if self.class.keeps
          return persist_attribs.select{ |attrib| attrib =~ self.class.keeps }
        end
        persist_attribs
      end

      # Return persistable attributes, pruning undesirable attributes.
      # The default implementation also prunes attribute with nil values, since
      # those are likely to default in persistence.
      # Either keeps or prunes are typically set, possibly both.
      def prune(persist_attribs)
        if self.class.prunes
          return persist_attribs.reject{ |attrib,value| attrib =~ self.class.prunes || value.nil? }
        end
        persist_attribs
      end

      # Persist a virtual resource
      def make_persistable(resource)
        if resource.class == self.class.persistent_type()
          return resource
        end
        persist_attribs = resource.attributes
        persist_attribs = self.keep(persist_attribs)
        persist_attribs = self.prune(persist_attribs)
        persisted = self.class.persistent_type().new(persist_attribs)
        persisted.live_resource = self
        persisted
      end

      # Return a token to signify output from the current action
      def output_token(args={})
        nil
      end

    end
  end
end

require "harp-runtime/resources/autoscaling/types"
require "harp-runtime/resources/beanstalk/types"
require "harp-runtime/resources/compute/types"
require "harp-runtime/resources/elastic_load_balancing/types"
require "harp-runtime/resources/rds/types"
require "harp-runtime/resources/elasticache/types"
require "harp-runtime/resources/assembly/types"

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

__END__
Other types to be defined:
DONE Auto Scaling Policy
Auto Scaling Trigger
Alarm
DONE Compute External Gateway
DONE Compute EC2 DHCP Options
DONE Compute Elastic IP Address
DONE Compute Elastic IP Address Association
DONE Compute Instance
DONE Compute Internet Gateway
Compute Network ACL
Compute Network ACL Entry
DONE Compute NetworkInterface
DONE Compute Route
DONE Compute Route Table
DONE Compute Security Group
Compute Security Group Ingress
Compute Security Group Egress
DONE Compute Subnet
Compute Subnet Network ACL Association
Compute Subnet Route Table Association
DONE Compute Volume
DONE Compute Volume Attachment
DONE Compute VPC
DONE Compute VPC Dhcp Options Association
DONE Compute VPC Gateway Attachment
Compute VPN Connection
Compute VPN Gateway
Cache Cache Cluster
Cache Parameter Group
Cache Security Group
Cache Security Group Ingress
DONE Elastic Application
DONE Elastic Environment
DONE Load Balancer
Identity Access Key
Identity Group
Identity Instance Profile
Identity Policy
Identity Role
Identity Add User to Group
Identity User
DONE Relational Database DBInstance
Relational Database DB Subnet Group
DONE Relational Database DBSecurityGroup
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
