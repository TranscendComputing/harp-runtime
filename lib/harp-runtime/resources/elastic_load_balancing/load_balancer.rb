require 'set'
require 'fog/core/model'
require 'harp-runtime/models/elastic_load_balancing'

module Harp
  module Resources

    class LoadBalancer < AvailableResource

      include Harp::Resources

      attribute :id,                    :aliases => 'LoadBalancerName'
      attribute :availability_zones,    :aliases => 'AvailabilityZones'
      attribute :created_at,            :aliases => 'CreatedTime'
      attribute :dns_name,              :aliases => 'DNSName'
      attribute :health_check,          :aliases => 'HealthCheck'
      attribute :instances,             :aliases => 'Instances'
      attribute :source_group,          :aliases => 'SourceSecurityGroup'
      attribute :hosted_zone_name,      :aliases => 'CanonicalHostedZoneName'
      attribute :hosted_zone_name_id,   :aliases => 'CanonicalHostedZoneNameID'
      attribute :subnet_ids,            :aliases => 'Subnets'
      attribute :security_groups,       :aliases => 'SecurityGroups'
      attribute :scheme,                :aliases => 'Scheme'
      attribute :vpc_id,                :aliases => 'VPCId'
      attribute :listeners

      register_resource :load_balancer, RESOURCES_ELASTIC_LOAD_BALANCING

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$|^name$/
      
      @output = false

      def self.persistent_type()
        ::LoadBalancer
      end

      def create(service)
        create_attribs = self.attribs[:attributes]
        create_attribs[:tags] = {"Name" => @name}
        create_attribs[:id] = @name
        load_balancer = service.load_balancers.create(create_attribs)
        @id = load_balancer.id
        return load_balancer
      end
      
      def destroy(service)
        destroy_attribs = self.attribs
        if @id
          load_balancer = service.load_balancers.destroy(destroy_attribs)
        else
          puts "No ID set, cannot delete."
        end
        return load_balancer
      end

    end
  end
end