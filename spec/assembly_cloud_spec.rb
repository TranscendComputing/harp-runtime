require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

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
    "client_key" => "~/chef_keys/harp-client.pem",
    "validator_client" => "momentumsidev-validator",
    "validator_path" => "~/chef_keys/momentumsidev-validator.pem",
    "ssh" => {
      "user" => "ubuntu",
      "keys" => ["~/chef_keys/dev-client-ec2.pem"],
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
    {"name" => "transcend_nexus","type" => "class"},
    {"name" => "transcend_sonar","type" => "class"}
  ]
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
  let(:assembly_chef) do
    @new_assembly_chef = mutator.create("ChefAssembly", assembly_chef_resource)
    @new_assembly_chef.instance_variable_get(:@id)
  end
  let(:assembly_puppet) do
    @new_assembly_puppet = mutator.create("PuppetAssembly", assembly_puppet_resource)
    @new_assembly_puppet.instance_variable_get(:@id)
  end
  let(:assembly_salt) do
    @new_assembly_salt = mutator.create("SaltAssembly", assembly_salt_resource)
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
  end
  it "creates an assembly_puppet" do
    pending "pending due to need of live instance"
    assembly_puppet
    verify_created(@new_assembly_puppet, "PuppetAssembly", AssemblyPuppet)
  end
  it "creates an assembly_salt" do
    pending "pending due to need of live instance"
    assembly_salt
    verify_created(@new_assembly_salt, "SaltAssembly", AssemblySalt)
  end
end