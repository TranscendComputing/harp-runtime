require 'set'
require 'fog/core/model'
require 'harp-runtime/models/assembly'
require 'harp-runtime/resources/assembly/assembly'
require 'json'

#require 'ridley'
require 'ridley-connectors'

module Harp
  module Resources

    class AssemblyChef < Assembly

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

      register_resource :assembly_chef, RESOURCES_ASSEMBLY

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$/

      def self.persistent_type()
        ::AssemblyChef
      end
      
      def provision_server(server_ip)
        ridley = init_ridley(config)
        @boot_counter = 0
        bootstrap_server(ridley,server_ip,parse_packages)
      end
      
      def bootstrap_server(ridley,server_ip,parse_packages)
        @boot_counter += 1
        begin
          puts "waiting 60 seconds for bootstrap: " + server_ip
          sleep(60)
          ridley.node.bootstrap(server_ip,run_list: parse_packages)
        rescue
          raise 'Bootstrap timeout error' if @boot_counter > 5
          puts "retrying bootstrap: " + server_ip
          bootstrap_server(ridley,server_ip,parse_packages)
        end
      end
      
      def destroy_provisioner(private_dns_name)
        ridley = init_ridley(config)
        ridley.node.delete(private_dns_name)
        ridley.client.delete(private_dns_name)
      end
      
      def parse_packages
        run_list = []
        packages.each { |p| run_list << p['type'] + "[" + p['name'] +"]"}
        run_list
      end
      
      def init_ridley(config)
        defaults = {"winrm" => {"port" => 5985},"ssh" => {"port" => 22}}
        defaults.merge!(config)
        ridley = Ridley.new(
          server_url: defaults['server_url'],
          client_name: defaults['client_name'],
          client_key: defaults['client_key'],
          validator_client: defaults['validator_client'],
          validator_path: defaults['validator_path'],
          ssh: {
            user: defaults['ssh']['user'],
            password: defaults['ssh']['password'],
            keys: defaults['ssh']['keys'],
            port: defaults['ssh']['port'],
            sudo: defaults['ssh']['sudo']
          },
          winrm: {
            user: defaults['winrm']['user'],
            password: defaults['winrm']['password'],
            port: defaults['winrm']['port']
          }
        )
        return ridley
      end
      
      def get_provisioner_output(service, persisted)
        server = service.servers.get(persisted.id)
        server.username = config["ssh"]["user"]
        server.private_key_path = config["ssh"]["keys"][0]
        output = "chef-client: \n"
        output += "/etc/chef/client.rb: \n"
        output += server.ssh(['cat /etc/chef/client.rb'])[0].stdout
        output += "\n/etc/chef/first-boot.json: \n"
        output += server.ssh(['cat /etc/chef/first-boot.json'])[0].stdout
        output
      end

    end
  end
end
