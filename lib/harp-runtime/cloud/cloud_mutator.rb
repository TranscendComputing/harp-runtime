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
      end

      def establish_connect(resource_type)
        if Harp::Resources::RESOURCES_COMPUTE.include? resource_type.class
          if ! @compute.nil?
            return @compute
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
        service = establish_connect(resource)
        created = resource.create(service)
        #case resource
        #when Harp::Resources::COMPUTE_INSTANCE
        #  args = from_resource(resource_name, resource_def)
        #  args[:name] = resource_name
        #  server = @compute.servers.create(args)
        #end
      end

      def from_resource(resource_name, resource_def)
        std_resource = resource_name [/^Std::(\w+)/, 1]
        args = {}
        resource_def.keys.each do |arg_key|
          args[arg_key] = resource_def[arg_key]
        end
        args
      end

      def typify(resource_name, resource_def)
        std_resource = resource_name [/^Std::(\w+)/, 1]
        args = {}
        resource_def.keys.each do |arg_key|
          args[arg_key] = resource_def[arg_key]
        end
        args
      end
    end
  end
end
