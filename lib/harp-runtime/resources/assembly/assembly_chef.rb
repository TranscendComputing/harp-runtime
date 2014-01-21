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
      
      attribute :private_ip_address,       :aliases => 'privateIpAddress'
      attribute :public_ip_address,        :aliases => 'ipAddress'

      register_resource :assembly_chef, RESOURCES_ASSEMBLY

      # Only keeping a few properties, simplest define keeps.
      @keeps = /^id$|^.*_ip_address/

      def self.persistent_type()
        ::AssemblyChef
      end

      def provision_server(server_ip,ridley)
        @boot_counter = 0
        bootstrap_server(ridley,server_ip,parse_packages)
      end

      def bootstrap_server(ridley,server_ip,parse_packages)
        @boot_counter += 1
        begin
          puts "waiting 60 seconds for bootstrap: " + server_ip
          sleep(60)
          ridley.node.bootstrap(server_ip,run_list: parse_packages)
          @client_key.unlink
          @validator_key.unlink
          @ssh_key.unlink
        rescue
          raise 'Bootstrap timeout error' if @boot_counter > 5
          puts "retrying bootstrap: " + server_ip
          bootstrap_server(ridley,server_ip,parse_packages)
        end
      end

      def destroy_provisioner(private_dns_name)
        ridley = init_provisioner
        ridley.node.delete(private_dns_name)
        ridley.client.delete(private_dns_name)
        @client_key.unlink
        @validator_key.unlink
        @ssh_key.unlink
      end

      def parse_packages
        run_list = []
        packages.each { |p| run_list << p['type'] + "[" + p['name'] +"]"}
        run_list
      end

      def init_provisioner
        defaults = {"winrm" => {"port" => 5985},"ssh" => {"port" => 22}}
        defaults.merge!(config)
        @client_key = Key.get_by_name(defaults['client_key']).temp_file
        @validator_key = Key.get_by_name(defaults['validator_path']).temp_file
        @ssh_key = Key.get_by_name(defaults['ssh']['keys'][0]).temp_file
        ridley = Ridley.new(
          server_url: defaults['server_url'],
          client_name: defaults['client_name'],
          client_key: @client_key.path,
          validator_client: defaults['validator_client'],
          validator_path: @validator_key.path,
          ssh: {
            user: defaults['ssh']['user'],
            password: defaults['ssh']['password'],
            keys: [@ssh_key.path],
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
        @ssh_key = Key.get_by_name(config['ssh']['keys'][0]).temp_file
        server.private_key_path = @ssh_key.path
        output = "chef-client: \n"
        output += "/etc/chef/client.rb: \n"
        output += server.ssh(['cat /etc/chef/client.rb'])[0].stdout
        output += "\n/etc/chef/first-boot.json: \n"
        output += server.ssh(['cat /etc/chef/first-boot.json'])[0].stdout
        @ssh_key.unlink
        output
      end

    end
  end
end
