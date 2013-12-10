require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

instance_resource = {
  "type" => "Std::ComputeInstance",
  "imageId" => "ami-d0f89fb9",
  "instanceType" => "t1.micro"
}

ins_for_asso = {
  "type" => "Std::ComputeInstance",
  "imageId" => "ami-d0f89fb9",
  "instanceType" => "t1.micro"
}

eip_for_asso = {
  "type" => "Std::ElasticIP",
  "server_id" => ""
}

eip_association_resource = {
  "type" => "Std::ElasticIPAssociation",
  "allocation_id" => "",
  "server_id"     => ""
}

elastic_ip_resource = {
  "type" => "Std::ElasticIP"
}

eip_association_resource = {
  "type" => "Std::ElasticIPAssociation",
}

security_group_resource = {
  "type" => "Std::SecurityGroup",
  "name" => "web-security-group",
  "description" => "A web security group"
}

security_group_resource_2 = {
  "type" => "Std::SecurityGroup",
  "name" => "web-security-group-2",
  "description" => "A web security group 2"
}

volume_resource = {
  "type" => "Std::Volume",
  "availability_zone" => "us-east-1",
  "size" => 5
}

vpc_resource = {
  "type" => "Std::Vpc",
  "cidr_block" => "10.1.2.0/24"
}

describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"

  it "creates elastic ip" do
    result = mutator.create("test_eip1", elastic_ip_resource)
    expect(result.class).to eq(ElasticIP)
    expect(result.name).to eq("test_eip1")
  end

  it "creates elastic ip association" do
    inst = mutator.create("ins_for_asso", ins_for_asso)
    eip_for_asso["server_id"] = inst.instance_variable_get(:@id)
    
    eip  = mutator.create("eip_for_asso", eip_for_asso)
    eip_association_resource["public_ip"] = eip.instance_variable_get(:@id)
    eip_association_resource["server_id"]     = inst.instance_variable_get(:@id)

    result = mutator.create("test_eip_asso", eip_association_resource)
    expect(result.class).to eq(ElasticIPAssociation)
    expect(result.name).to eq("test_eip_asso")
  end

  it "creates a cloud instance" do
    result = mutator.create("test_inst1", instance_resource)
    expect(result.class).to eq(ComputeInstance)
    expect(result.name).to eq("test_inst1")
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
  
  it "creates a vpc" do
    result = mutator.create("test_vpc1", vpc_resource)
    expect(result.class).to eq(Vpc)
    expect(result.name).to eq("test_vpc1")
  end
end

describe Harp::Cloud::CloudMutator, "#destroy" do
  include_context "when have mutator"
  
	it "destroys a cloud instance" do
    created = mutator.create("test_inst1", instance_resource)
    result = mutator.destroy("test_inst1", instance_resource)
    expect(result.class).to eq(ComputeInstance)
    expect(result.name).to eq("test_inst1")
  end
	it "destroys an elastic ip" do
    created = mutator.create("test_eip2", elastic_ip_resource)
    result = mutator.destroy("test_eip2", elastic_ip_resource)
    expect(result.class).to eq(ElasticIP)
    expect(result.name).to eq("test_eip2")
  end
  it "destroys an elastic ip association" do
    inst = mutator.create("ins_for_asso", ins_for_asso)
    eip_for_asso["server_id"] = inst.instance_variable_get(:@id)
    
    eip  = mutator.create("eip_for_asso", eip_for_asso)
    eip_association_resource["public_ip"] = eip.instance_variable_get(:@id)
    eip_association_resource["server_id"]     = inst.instance_variable_get(:@id)

    created = mutator.create("test_eip_asso", eip_association_resource)
    result = mutator.destroy("test_eip_asso", eip_association_resource)
    expect(result.name).to eq("test_eip_asso")
    expect(result.class).to eq(ElasticIPAssociation)
  end
  it "destroys a security group" do
    created = mutator.create("test_sg2", security_group_resource_2)
    result = mutator.destroy("test_sg2", security_group_resource_2)
    expect(result.class).to eq(SecurityGroup)
    expect(result.name).to eq("test_sg2")
  end
  it "destroys a volume" do
    created = mutator.create("test_vol1", volume_resource)
    result = mutator.destroy("test_vol1", volume_resource)
    expect(result.class).to eq(Volume)
    expect(result.name).to eq("test_vol1")
  end
end
