require 'set'
require 'fog/core/model'
require 'harp-runtime/models/beanstalk'
require 'json'

module Harp
  module Resources

    class ElasticEnvironment < AvailableResource

      include Harp::Resources

        attribute :name,                :aliases => 'EnvironmentName'
        attribute :id,                  :aliases => 'EnvironmentId'

        attribute :application_name,    :aliases => 'ApplicationName'
        attribute :cname,               :aliases => 'CNAME'
        attribute :cname_prefix,        :aliases => 'CNAMEPrefix'
        attribute :created_at,          :aliases => 'DateCreated'
        attribute :updated_at,          :aliases => 'DateUpdated'
        attribute :updated_at,          :aliases => 'DateUpdated'
        attribute :description,         :aliases => 'Description'
        attribute :endpoint_url,        :aliases => 'EndpointURL'
        attribute :health,              :aliases => 'Health'
        attribute :resources,           :aliases => 'Resources'
        attribute :solution_stack_name, :aliases => 'SolutionStackName'
        attribute :status,              :aliases => 'Status'
        attribute :template_name,       :aliases => 'TemplateName'
        attribute :version_label,       :aliases => 'VersionLabel'
        attribute :option_settings,     :aliases => 'OptionSettings'
        attribute :options_to_remove,   :aliases => 'OptionsToRemove'
        attribute :description
        attribute :state
        attribute :type
        attribute :live_resource
        
      register_resource :elastic_environment, RESOURCES_BEANSTALK

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/

      def self.persistent_type()
        ::ElasticEnvironment
      end


      def create(service)
        create_attribs = self.attribs
        environment = service.environments.create(create_attribs)
        return environment
      end

      def destroy(service)
        if id
          environment = service.environments.destroy(id)
        else
          raise "No ID set, cannot delete."
        end
        return environment
      end

    end
  end
end
