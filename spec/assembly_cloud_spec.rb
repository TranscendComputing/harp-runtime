require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"
require "httparty"

server_options = {
  "image_id" => "ami-d0f89fb9",
  "flavor_id" => "t1.micro",
  "key_name" => "dev-client-ec2",
  "groups" => ["launch-wizard-2"]
}

assembly_chef_resource = {
  "type" => "Std::AssemblyChef",
  "server_options" => server_options,

  "name" => "ChefAssembly",
  "image" => "ami-d0f89fb9",
  "packages" => [
    {"name" => "apt","type" => "recipe"},
    {"name" => "apache2","type" => "recipe"}
  ],
  "config" => {
    "server_url" => "https://api.opscode.com/organizations/momentumsidev",
    "client_name" => "harp-client",
    "client_key" => "harp-client",
    "validator_client" => "momentumsidev-validator",
    "validator_path" => "momentumsidev-validator",
    "ssh" => {
      "user" => "ubuntu",
      "keys" => ["dev-client-ec2"],
      "port" => 22,
      "sudo" => true
    }
  }
}

assembly_puppet_resource = {
  "type" => "Std::AssemblyPuppet",
  "server_options" => server_options,

  "name" => "PuppetAssembly",
  "image" => "ami-d0f89fb9",
  "packages" => [
    {"name" => "apache","type" => "class"},
    {"name" => "ntp","type" => "class"}
  ],
  "config" => {
    "server_url" => "54.205.121.185",
    "ssh" => {
      "user" => "ubuntu",
      "keys" => ["dev-client-ec2"]
    }
  }
}

assembly_salt_resource = {
  "type" => "Std::AssemblySalt",
  "server_options" => server_options,

  "name" => "SaltAssembly",
  "image" => "ami-d0f89fb9",
  "packages" => [
    {"name" => "activemq","type" => "recipe","version" => "1.0.0"},
    {"name" => "apparmor","type" => "recipe","version" => "0.9.0"},
    {"name" => "apt",     "type" => "recipe","version" => "1.1.2"}
  ]
}

shared_context 'when have an assembly' do
  let(:mutator_assembly) {
    cnf = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), '../config/settings.yaml'))
    FactoryGirl.create(:key, name: "dev-client-ec2", value: cnf['default_creds']['dev-client-ec2'])
    FactoryGirl.create(:key, name: "harp-client", value: cnf['default_creds']['harp-client'])
    FactoryGirl.create(:key, name: "momentumsidev-validator", value: cnf['default_creds']['momentumsidev-validator'])
    PuppetENC.first_or_create(:master_ip=>"www.momentumsi.com").update(:yaml=>nil)
    interpreter_context = {}
    interpreter_context[:cloud_type] = :aws # for the moment, assume AWS cloud
    interpreter_context[:debug] = true
    interpreter_context[:access] = cnf['default_creds']['access']
    interpreter_context[:secret] = cnf['default_creds']['secret']
    interpreter_context[:harp_script] = FactoryGirl.create(:harp_script)
    interpreter_context
    Harp::Cloud::CloudMutator.new(interpreter_context)
  }
  let(:assembly_chef) do
    @new_assembly_chef = mutator_assembly.create("ChefAssembly", assembly_chef_resource)
    @new_assembly_chef.instance_variable_get(:@id)
  end
  let(:assembly_puppet) do
    @new_assembly_puppet = mutator_assembly.create("PuppetAssembly", assembly_puppet_resource)
    @new_assembly_puppet.instance_variable_get(:@id)
  end
  let(:assembly_salt) do
    @new_assembly_salt = mutator_assembly.create("SaltAssembly", assembly_salt_resource)
    @new_assembly_salt.instance_variable_get(:@id)
  end
end

describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"
  include_context "when have an assembly"
  it "creates an assembly_chef" do
    pending "pending due to need of live instance"
    assembly_chef
    verify_created(@new_assembly_chef, "ChefAssembly", AssemblyChef)
    expect(HTTParty.get("http://#{@new_assembly_chef.public_ip_address}").code).to eq(200)
    mutator_assembly.destroy("ChefAssembly", assembly_chef_resource)
  end
  it "creates an assembly_puppet" do
    pending "pending due to need of live instance"
    assembly_puppet
    verify_created(@new_assembly_puppet, "PuppetAssembly", AssemblyPuppet)
    begin
      sleep(60)
      expect(HTTParty.get("http://#{@new_assembly_puppet.public_ip_address}").code).to eq(200)
    rescue
      sleep(60)
      expect(HTTParty.get("http://#{@new_assembly_puppet.public_ip_address}").code).to eq(200)
    end
    mutator_assembly.destroy("PuppetAssembly", assembly_puppet_resource)
  end
  it "creates an assembly_salt" do
    pending "pending due to need of live instance"
    assembly_salt
    verify_created(@new_assembly_salt, "SaltAssembly", AssemblySalt)
  end
end
