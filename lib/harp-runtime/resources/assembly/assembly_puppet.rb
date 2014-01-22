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
        # internal_dns = @service.servers.get(id).private_dns_name
#         PuppetENC.first_or_create(:master_ip=>internal_dns).update(:master_ip=>internal_dns,:yaml=>parse_packages)
        server = @service.servers.find{|i| i.public_ip_address == config['server_url'] || i.dns_name == config['server_url']}
        server.username = config["ssh"]["user"]
        @ssh_key = Key.get_by_name(config['ssh']['keys'][0]).temp_file
        server.private_key_path = @ssh_key.path
        server.ssh(['echo "'+parse_packages+'" > /usr/local/bin/puppet_node_classifiers/'+@service.servers.get(id).private_dns_name.downcase])[0].stdout
        @ssh_key.unlink
        bootstrap_server
      end

      def bootstrap_server
        server = @service.servers.get(id)
        server.username = config["ssh"]["user"]
        @ssh_key = Key.get_by_name(config['ssh']['keys'][0]).temp_file
        server.private_key_path = @ssh_key.path
        begin
          bootstrap(server)
        rescue
          sleep(20)
          bootstrap(server)
        end
        @ssh_key.unlink
      end
      
      def bootstrap(server)
        server.ssh(["sudo apt-get update && apt-get -y upgrade"])[0].stdout
        server.ssh(["sudo aptitude -y install puppet"])[0].stdout
        server.ssh(["sudo sed -i /etc/default/puppet -e 's/START=no/START=yes/'"])[0].stdout
        server.ssh(["sudo sed -i -e '/\[main\]/{:a;n;/^$/!ba;i\pluginsync=true' -e '}' /etc/puppet/puppet.conf"])[0].stdout
        server.ssh(["sudo service puppet restart"])[0].stdout
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
        server = service.servers.get(persisted.id)
        server.username = config["ssh"]["user"]
        @ssh_key = Key.get_by_name(config['ssh']['keys'][0]).temp_file
        server.private_key_path = @ssh_key.path
        output = "puppet: \n"
        output += server.ssh(['sudo cat /var/log/syslog'])[0].stdout
        @ssh_key.unlink
        output
      end

    end
  end
end
