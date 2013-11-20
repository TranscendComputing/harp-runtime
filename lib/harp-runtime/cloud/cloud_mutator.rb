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
        @compute = nil
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
        persist_resource(resource_name, resource, "create")
      end

      def destroy(resource_name, resource_def)
        resource = Harp::Resources::AvailableResource.from_name resource_def['type']
        if resource.nil?
          @@logger.error "No resource type #{resource_def['type']}"
          return
        end
        resource.populate(resource_def)
        resource.name = resource_name
        service = establish_connect(resource)
        destroyed = resource.destroy(service)
        persist_resource(resource_name, resource, "destroy")
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

      def get_state(resource_name)
        resource = Harp::Resources::AvailableResource.from_name resource_def['type']
        if resource.nil?
          @@logger.error "No resource type #{resource_def['type']}"
          return
        end
        # TODO: fetch state of resource.
      end
      private
          def persist_resource(resource_name, resource, action)
            resource = resource.make_persistable(resource)
            resource.name = resource_name
            @@logger.debug "Perform: #{action} resource #{resource.inspect}"
            resource
          end
    end
  end
end
