require 'set'
require 'fog/core/model'
require 'harp-runtime/models/beanstalk'
require 'json'

module Harp
  module Resources

    class ElasticApplication < AvailableResource

      include Harp::Resources

        attribute :id,                :aliases => 'ApplicationId'
        attribute :name,              :aliases => 'ApplicationName'
        attribute :template_names,    :aliases => 'ConfigurationTemplates'
        attribute :created_at,        :aliases => 'DateCreated'
        attribute :updated_at,        :aliases => 'DateUpdated'
        attribute :description,       :aliases => 'Description'
        attribute :version_names,     :aliases => 'Versions'
        attribute :description
        attribute :state
        attribute :type
        attribute :live_resource

      register_resource :elastic_application, RESOURCES_BEANSTALK

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/

      # Return persistable attributes with only desired attributes to keep 
      def keep(attribs)
        attribs[:public_ip_address] = attribs[:public_ip]
        super
      end

      def self.persistent_type()
        ::ElasticApplication
      end


      def create(service)
        create_attribs = self.attribs
        application = service.applications.create(create_attribs)
        return application
      end

      def destroy(service)
        if id
          application = service.applications.destroy(id)
        else
          puts "No ID set, cannot delete."
        end
        return application
      end

    end
  end
end
