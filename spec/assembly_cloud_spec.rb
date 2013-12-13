require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

instance_resource = {
  "type" => "Std::ComputeInstance",
  "imageId" => "ami-d0f89fb9",
  "instanceType" => "t1.micro"
}

assembly_chef_resource = {
  "type" => "Std::AssemblyChef",
  "server_options" => instance_resource,
  
  "name" => "ActiveMQ",
  "image" => "ami-d0f89fb9",
  "packages" => [
    {"name" => "activemq","type" => "recipe","version" => "1.0.0"},
    {"name" => "apparmor","type" => "recipe","version" => "0.9.0"},
    {"name" => "apt",     "type" => "recipe","version" => "1.1.2"}
  ]
}

assembly_puppet_resource = {
  "type" => "Std::AssemblyPuppet",
  "server_options" => instance_resource,
  
  "name" => "ActiveMQ",
  "image" => "ami-d0f89fb9",
  "packages" => [
    {"name" => "transcend_nexus","type" => "class"},
    {"name" => "transcend_sonar","type" => "class"}
  ]
}

assembly_salt_resource = {
  "type" => "Std::AssemblySalt",
  "server_options" => instance_resource,
  
  "name" => "ActiveMQ",
  "image" => "ami-d0f89fb9",
  "packages" => [
    {"name" => "activemq","type" => "recipe","version" => "1.0.0"},
    {"name" => "apparmor","type" => "recipe","version" => "0.9.0"},
    {"name" => "apt",     "type" => "recipe","version" => "1.1.2"}
  ]
}

shared_context 'when have an assembly' do
  let(:assembly_chef) do
    @new_assembly_chef = mutator.create("ActiveMQ", assembly_chef_resource)
    @new_assembly_chef.instance_variable_get(:@id)
  end
  let(:assembly_puppet) do
    @new_assembly_puppet = mutator.create("ActiveMQ", assembly_puppet_resource)
    @new_assembly_puppet.instance_variable_get(:@id)
  end
  let(:assembly_salt) do
    @new_assembly_salt = mutator.create("ActiveMQ", assembly_salt_resource)
    @new_assembly_salt.instance_variable_get(:@id)
  end
end

describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"
  include_context "when have an assembly"
  it "creates an assembly_chef" do
    assembly_chef
    verify_created(@new_assembly_chef, "ActiveMQ", AssemblyChef)
  end
  it "creates an assembly_puppet" do
    assembly_puppet
    verify_created(@new_assembly_puppet, "ActiveMQ", AssemblyPuppet)
  end
  it "creates an assembly_salt" do
    assembly_salt
    verify_created(@new_assembly_salt, "ActiveMQ", AssemblySalt)
  end
end