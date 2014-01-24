require 'set'
require 'fog/core/model'
require 'harp-runtime/models/assembly'
require 'harp-runtime/resources/assembly/assembly'
require 'json'

module Harp
  module Resources

    class AssemblySalt < Assembly

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
      
      attribute :packages
      attribute :server_options

      register_resource :assembly_salt, RESOURCES_ASSEMBLY

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/

      def self.persistent_type()
        ::AssemblySalt
      end
      
      def init_provisioner
        bootstrap_file  = File.open(File.expand_path("../salt-bootstrap/salt_bootstrap.sh", __FILE__)).read
        user_data = ""
        line_num=0
        bootstrap_file.each_line do |line|
          if line_num == 0
            user_data << line
            line_num += 1
            user_data << 'packages_yaml="' + parse_packages + '"'
            line_num += 1
          else
            user_data << line
            line_num += 1
          end
        end
        server_options["user_data"] = user_data
      end
      
      def parse_packages
        yaml_hash = {}
        packages.each do |p| 
          yaml_hash[p['name']] = {'pkg'=>['installed']}
        end
        yaml_hash.to_yaml
      end
      
      def provision_server(server_ip,provisioner)
        server = @service.servers.get(id)
        server.username = config["ssh"]["user"]
        @ssh_key = Key.get_by_name(config['ssh']['keys'][0]).temp_file
        server.private_key_path = @ssh_key.path
        @boot_counter = 0
        bootstrap(server)
        @ssh_key.unlink
      end
      
      def bootstrap(server)
        @boot_counter += 1
        begin
          puts "waiting 30 seconds for bootstrap..."
          sleep(30)
          puts server.ssh(["wget -O - http://bootstrap.saltstack.org | sudo sh"])[0].stdout
          puts server.ssh(["sudo salt-call --local state.highstate -l debug"])[0].stdout
        rescue
          raise 'Bootstrap timeout error' if @boot_counter > 15
          puts "retrying bootstrap: "
          bootstrap(server)
        end
      end
      
      def destroy_provisioner(private_dns_name)
      end

    end
  end
end
