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
        destroy_attribs = self.attribs
        if @id
          environment = service.environments.destroy(destroy_attribs)
        else
          puts "No ID set, cannot delete."
        end
        return environment
      end

    end
  end
end
