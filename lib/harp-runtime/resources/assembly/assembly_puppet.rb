require 'set'
require 'fog/core/model'
require 'harp-runtime/models/assembly'
require 'harp-runtime/resources/assembly/assembly'
require 'json'

module Harp
  module Resources

    class AssemblyPuppet < Assembly

      include Harp::Resources

      identity  :id
      attribute :description
      attribute :live_resource
      attribute :state
      attribute :type

      attribute :name
      attribute :cloud
      attribute :configurations
      attribute :tool
      attribute :cloud_credential
      attribute :image

      attribute :config
      attribute :packages
      attribute :server_options

      register_resource :assembly_puppet, RESOURCES_ASSEMBLY

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/

      def self.persistent_type()
        ::AssemblyPuppet
      end

      def init_provisioner
        bootstrap_file  = File.open(File.expand_path("../puppet-bootstrap/ubuntu.sh", __FILE__)).read
        user_data = ""
        line_num=0
        bootstrap_file.each_line do |line|
          if line_num == 0
            user_data << line
            line_num += 1
            user_data << "puppet_master_ip=" + config["server_url"]
            line_num += 1
          else
            user_data << line
            line_num += 1
          end
        end
        server_options["user_data"] = user_data
      end

      def provision_server(server_ip,provisioner)
        internal_dns = @service.servers.get(id).private_dns_name
        PuppetENC.first_or_create(:master_ip=>internal_dns).update(:master_ip=>internal_dns,:yaml=>parse_packages)
      end

      def bootstrap_server(provisioner,server_ip,parse_packages)
      end

      def destroy_provisioner(private_dns_name)
      end

      def parse_packages
        classes_list = []
        packages.each { |p| classes_list << p['name']}
        yaml_hash = {"classes"=>classes_list}
        yaml_hash.to_yaml
      end

      def get_provisioner_output(service, persisted)
      end

    end
  end
end
