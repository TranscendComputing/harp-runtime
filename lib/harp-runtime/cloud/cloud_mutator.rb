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

      def establish_connect(resource_def)
        if Harp::Resources::RESOURCES_COMPUTE.include? resource_def['type']
          if ! @compute.nil?
            return
          end
          @compute = Fog::Compute.new(:provider => 'AWS',
            :aws_access_key_id => @access, :aws_secret_access_key => @secret)
        end
      end

      def create(resource_name, resource_def)
        establish_connect(resource_def)
        case resource_def['type']
        when Harp::Resources::COMPUTE_INSTANCE
          args = args_from_resource(resource_def)
          args[:name] = resource_name
          server = @compute.servers.create(args)
        end
      end

      def args_from_resource(resource_def)
        return {}
      end

    end
  end
end
