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
  "type" => "Std::ElasticIP",
  "public_ip" => "123.4.5.6"
}

eip_association_resource = {
  "type" => "Std::ElasticIPAssociation",
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

  it "creates elastic ip association" do
    inst = mutator.create("ins_asso", ins_for_asso)
    eip_for_asso["server_id"] = inst.instance_variable_get(:@id)
    
    eip  = mutator.create("eip_asso", eip_for_asso)
    eip_association_resource["allocation_id"] = eip.instance_variable_get(:@id)
    eip_association_resource["server_id"]     = inst.instance_variable_get(:@id)


    result = mutator.create("test_eip_asso1", eip_association_resource)
    expect(result.class).to eq(ElasticIPAssociation)
    expect(result.name).to eq("test_eip_asso1")
    expect(result.state).to eq(Harp::Resources::AvailableResource::CREATED)
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
	it "destroys a cloud instance" do
		context = {}
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    mutator = Harp::Cloud::CloudMutator.new(context)

    result = mutator.destroy("test_inst1", instance_resource)
    
    expect(result.class).to eq(ComputeInstance)
    expect(result.name).to eq("test_inst1")
    expect(result.state).to eq(Harp::Resources::AvailableResource::DESTROYED)
  end
end
