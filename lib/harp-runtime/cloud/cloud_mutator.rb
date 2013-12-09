# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2

module Harp
  module Cloud

    require 'fog'

    # CloudMutator creates and changes resources on a cloud.
    class CloudMutator

      @@logger = Logging.logger[self]

      def initialize(options)
        @access = options[:access]
        @secret = options[:secret]
        @cloud_type = options[:cloud_type]
        @mock = (options.include? :mock) ? true : false
        @service_connectors = {}
        @harp_script = options[:harp_script]
        @resources = {}
      end

      def service_for_set(resource_set)
        case resource_set
        when Harp::Resources::RESOURCES_COMPUTE
          Fog::Compute
        when Harp::Resources::RESOURCES_RDS
          Fog::AWS::RDS
        when Harp::Resources::RESOURCES_ELASTIC_LOAD_BALANCING
          Fog::AWS::ELB
        when Harp::Resources::RESOURCES_AUTOSCALE
          Fog::AWS::AutoScaling
        else
        end
      end

      def make_service(resource_set, args)
        clazz = service_for_set(resource_set)
        if ! clazz
          raise "No service found for resource set: #{resource_set.inspect}"
        end
        if @service_connectors[clazz]
          return @service_connectors[clazz]
        end
        if ! clazz.name.include? "AWS"
          args[:provider] = 'AWS'
        end
        @service_connectors[clazz] = clazz.new(args)
      end

      def establish_connect(resource_type)
        if @mock
            Fog.mock!
        end
        args = {:aws_access_key_id => @access, :aws_secret_access_key => @secret}
        Harp::Resources::RESOURCE_SETS.each do |resource_set|
          if resource_set.include? resource_type.class
            return make_service(resource_set, args)
          end
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
        pr.state = Harp::Resources::AvailableResource::CREATED
        remember(pr)
        pr.save
        return pr
      end

      def destroy(resource_name, resource_def)
        resource = Harp::Resources::AvailableResource.from_name resource_def['type']
        if resource.nil?
          @@logger.error "No resource type #{resource_def['type']}"
          return
        end
        
        resource.populate(resource_def)
        persisted = get_harp_resource(resource_name)
        
        if ! persisted.nil?
          resource.populate(persisted.attributes)
        end
        
        resource.name = resource_name
        service = establish_connect(resource)
        
        destroyed = resource.destroy(service)
        #pr = persist_resource(resource_name, resource, resource, "destroy")
        #persisted.live_resource = resource
        persisted.state = Harp::Resources::AvailableResource::DESTROYED
        remember(persisted)
        persisted.save
        return persisted
      end

      def get_harp_resource(resource_name)
        #@harp_script.harp_resources.select{|res| res.name == resource_name}.first
        @resources[resource_name]
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

      def remember(resource)
        @resources[resource.name] = resource
      end
      
      def get_state(resource_name,resource_def)
        resource = Harp::Resources::AvailableResource.from_name resource_def['type']
        if resource.nil?
          @@logger.error "No resource type #{resource_def['type']}"
          return
        end
        resource.populate(resource_def)
        
        persisted = get_harp_resource(resource_name)
        if ! persisted.nil?
          resource.populate(persisted.attributes)
        end
        
        resource.name = resource_name
        service = establish_connect(resource)
        
        return resource.get_state(service)
      end
      private
          def persist_resource(resource_name, resource, live_resource, action)
            if live_resource
              persistable = resource.make_persistable(live_resource)
              persistable.name = resource_name
              persistable.harp_script_id = @harp_script.id
              @@logger.debug "Perform: #{action} resource #{persistable.inspect}"
              persistable
            end
          end
    end
  end
end
