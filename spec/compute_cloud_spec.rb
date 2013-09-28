require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

instance_resource = {
  "type" => "Std::ComputeInstance",
  "imageId" => "ami-d0f89fb9",
  "instanceType" => "t1.micro"
}

security_group_resource = {
  "type" => "Std::SecurityGroup",
  "name" => "web-security-group",
  "description" => "A web security group",
  "ip_permissions" => ""
}

describe Harp::Cloud::CloudMutator, "#create" do
	it "creates a cloud instance" do
		context = {}
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    mutator = Harp::Cloud::CloudMutator.new(context)

    result = mutator.create("test_inst1", instance_resource)
    expect(result.class).to eq(ComputeInstance)
    expect(result.name).to eq("test_inst1")
  end

  it "creates a security group" do
    context = {}
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    mutator = Harp::Cloud::CloudMutator.new(context)

    result = mutator.create("test_sg1", security_group_resource)
    expect(result.class).to eq(SecurityGroup)
    expect(result.name).to eq("test_sg1")
  end

end