require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

instance_resource = {
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

shared_context 'when have an instance' do
  let(:server_id) do
    inst = mutator.create("instance_resource", instance_resource)
    inst.instance_variable_get(:@id)
  end
end

shared_context 'when have an eip' do
  let(:eip) do
    @new_eip = mutator.create("test_eip1", elastic_ip_resource)
    @new_eip.instance_variable_get(:@id)
  end
  let(:eip_association) do
    eip_association_resource["public_ip"] = eip
    eip_association_resource["server_id"] = server_id
    @eip_association = mutator.create("test_eip_asso", eip_association_resource)
    @eip_association.instance_variable_get(:@id)
  end
end

describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"

  before do

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

  describe Harp::Cloud::CloudMutator, "#create eip" do
    include_context "when have an eip"

    it "creates elastic ip" do
      eip
      expect(@new_eip.class).to eq(ElasticIP)
      expect(@new_eip.name).to eq("test_eip1")
    end

    describe Harp::Cloud::CloudMutator, "#create eip_association" do
      include_context "when have an instance"

      it "creates elastic ip association" do

        eip_association
        expect(@eip_association.class).to eq(ElasticIPAssociation)
        expect(@eip_association.name).to eq("test_eip_asso")
      end
    end
  end

  it "creates a volume" do
    result = mutator.create("test_vol1", volume_resource)
    expect(result.class).to eq(Volume)
    expect(result.name).to eq("test_vol1")
  end
end

describe Harp::Cloud::CloudMutator, "#destroy" do
  include_context "when have mutator"

  describe Harp::Cloud::CloudMutator, "#destroy eip" do
    include_context "when have mutator"
    include_context "when have an eip"
    include_context "when have an instance"

    it "destroys an elastic ip" do
      eip
      result = mutator.destroy("test_eip1", elastic_ip_resource)
      expect(result.class).to eq(ElasticIP)
      expect(result.name).to eq("test_eip1")
    end

    describe Harp::Cloud::CloudMutator, "#destroy eip_association" do

      it "destroys an elastic ip association" do
        eip_association
        result = mutator.destroy("test_eip_asso", eip_association_resource)
        expect(result.name).to eq("test_eip_asso")
        expect(result.class).to eq(ElasticIPAssociation)
      end
    end
  end

	it "destroys a cloud instance" do
    created = mutator.create("test_inst1", instance_resource)
    result = mutator.destroy("test_inst1", instance_resource)
    expect(result.class).to eq(ComputeInstance)
    expect(result.name).to eq("test_inst1")
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
