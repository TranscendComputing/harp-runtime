require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

instance_resource = {
  "type" => "Std::ComputeInstance",
  "imageId" => "ami-d0f89fb9",
  "instanceType" => "t1.micro"
}

elastic_ip_resource = {
  "type" => "Std::ElasticIP",
  "public_ip" => "123.4.5.6"
}

security_group_resource = {
  "type" => "Std::SecurityGroup",
  "name" => "web-security-group",
  "description" => "A web security group"
}

volume_resource = {
  "type" => "Std::Volume",
  "availability_zone" => "us-east-1",
  "size" => 5
}

describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"

  it "creates elastic ip" do
    result = mutator.create("test_eip1", elastic_ip_resource)
    expect(result.class).to eq(ElasticIP)
    expect(result.name).to eq("test_eip1")
  end

  it "creates a cloud instance" do
    result = mutator.create("test_inst1", instance_resource)
    expect(result.class).to eq(ComputeInstance)
    expect(result.name).to eq("test_inst1")
    expect(result.state).to eq(Harp::Resources::AvailableResource::CREATED)
  end

  it "creates a security group" do
    result = mutator.create("test_sg1", security_group_resource)
    expect(result.class).to eq(SecurityGroup)
    expect(result.name).to eq("test_sg1")
    expect(result.description).to eq("A web security group")
  end
  
  it "creates a volume" do
    result = mutator.create("test_vol1", volume_resource)
    expect(result.class).to eq(Volume)
    expect(result.name).to eq("test_vol1")
  end
end

describe Harp::Cloud::CloudMutator, "#destroy" do
  include_context "when have mutator"
  
	it "destroys a cloud instance" do
    state = mutator.get_state("test_inst1", instance_resource)
    result = mutator.destroy("test_inst1", instance_resource)
    expect(result.class).to eq(ComputeInstance)
    expect(result.name).to eq("test_inst1")
    expect(result.state).to eq(Harp::Resources::AvailableResource::DESTROYED)
  end
	it "destroys an elastic ip" do
    result = mutator.destroy("test_eip1", elastic_ip_resource)
    
    expect(result.class).to eq(ElasticIP)
    expect(result.name).to eq("test_eip1")
    expect(result.state).to eq(Harp::Resources::AvailableResource::DESTROYED)
  end
	it "destroys a security group" do
    result = mutator.destroy("test_sg1", security_group_resource)
    
    expect(result.class).to eq(SecurityGroup)
    expect(result.name).to eq("test_sg1")
    expect(result.state).to eq(Harp::Resources::AvailableResource::DESTROYED)
  end
	it "destroys a volume" do
    result = mutator.destroy("test_vol1", volume_resource)
    
    expect(result.class).to eq(Volume)
    expect(result.name).to eq("test_vol1")
    expect(result.state).to eq(Harp::Resources::AvailableResource::DESTROYED)
  end
end
