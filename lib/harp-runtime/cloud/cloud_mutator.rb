# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2

module Harp
  module Cloud

    require 'fog'

    # CloudMutator creates and changes resources on a cloud.
    class CloudMutator

      @@logger = Logging.logger[self]
      DESTROYED = "DESTROYED"
      CREATED = "CREATED"

      def initialize(options)
        @access = options[:access]
        @secret = options[:secret]
        @cloud_type = options[:cloud_type]
        @compute = nil
        @rds = nil
        @elb = nil
        @mock = (options.include? :mock) ? true : false
      end

      def establish_connect(resource_type)
        if Harp::Resources::RESOURCES_COMPUTE.include? resource_type.class
          if ! @compute.nil?
            return @compute
          end
          if @mock
            Fog.mock!
          end
          @compute = Fog::Compute.new(:provider => 'AWS',
            :aws_access_key_id => @access, :aws_secret_access_key => @secret)
          return @compute
        elsif Harp::Resources::RESOURCES_RDS.include? resource_type.class
          if ! @rds.nil?
            return @rds
          end
          if @mock
            Fog.mock!
          end
          @rds = Fog::AWS::RDS.new({:aws_access_key_id => @access, :aws_secret_access_key => @secret})
          return @rds
        elsif Harp::Resources::RESOURCES_ELASTIC_LOAD_BALANCING.include? resource_type.class
          if ! @elb.nil?
            return @elb
          end
          if @mock
            Fog.mock!
          end
          @elb = Fog::AWS::ELB.new({:aws_access_key_id => @access, :aws_secret_access_key => @secret})
          return @elb
        end
      end

      def create(resource_name, resource_def)
        resource = Harp::Resources::AvailableResource.from_name resource_def['type']
        if resource.nil?
          @@logger.error "No resource type #{resource_def['type']}"
          return
        end
        resource.populate(resource_def)
        resource.name = resource_name
        service = establish_connect(resource)
        created = resource.create(service)
        pr = persist_resource(resource_name, resource, created, "create")
        pr.state = CREATED
        return pr
      end

      def destroy(resource_name, resource_def)
        resource = Harp::Resources::AvailableResource.from_name resource_def['type']
        if resource.nil?
          @@logger.error "No resource type #{resource_def['type']}"
          return
        end
        
        resource.populate(resource_def)
        persisted = HarpResource.entries.select{|res| res.name == resource_name}.first
        
        if ! persisted.nil?
          require 'pry'
          binding.pry
          puts resource.populate(persisted.attributes)
        end
        
        resource.name = resource_name
        service = establish_connect(resource)
        
        destroyed = resource.destroy(service)
        if !destroyed.nil?
          pr = persist_resource(resource_name, resource, resource, "destroy")
          pr.state = DESTROYED
          return pr
        else
          return nil
        end
      end

      def get_output(resource, persisted)
        resource = Harp::Resources::AvailableResource.from_name resource['type']
        if resource.nil?
          @@logger.error "No resource type #{resource_def['type']}"
          return
        end
        service = establish_connect(resource)
        output = resource.get_output(service, persisted)
      end

      def get_state(resource_name,resource_def)
        resource = Harp::Resources::AvailableResource.from_name resource_def['type']
        if resource.nil?
          @@logger.error "No resource type #{resource_def['type']}"
          return
        end
        resource.populate(resource_def)
        resource.name = resource_name
        service = establish_connect(resource)
        return resource.get_state(service)
      end
      private
          def persist_resource(resource_name, resource, live_resource, action)
            if live_resource
              persistable = resource.make_persistable(live_resource)
              persistable.name = resource_name
              @@logger.debug "Perform: #{action} resource #{persistable.inspect}"
              persistable
            end
          end
    end
  end
end
