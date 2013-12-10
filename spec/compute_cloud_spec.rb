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
    inst = mutator.create("test_inst1", instance_resource)
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
    verify_created(result, "test_inst1", ComputeInstance)
  end

  it "creates a security group" do
    result = mutator.create("test_sg1", security_group_resource)
    verify_created(result, "test_sg1", SecurityGroup)
    expect(result.description).to eq("A web security group")
  end

  describe Harp::Cloud::CloudMutator, "#create eip" do
    include_context "when have an eip"

    it "creates elastic ip" do
      eip
      verify_created(@new_eip, "test_eip1", ElasticIP)
    end

    describe Harp::Cloud::CloudMutator, "#create eip_association" do
      include_context "when have an instance"

      it "creates elastic ip association" do
        eip_association
        verify_created(@eip_association, "test_eip_asso", ElasticIPAssociation)
      end
    end
  end

  it "creates a volume" do
    result = mutator.create("test_vol1", volume_resource)
    verify_created(result, "test_vol1", Volume)
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
      verify_destroyed(result, "test_eip1", ElasticIP)
    end

    describe Harp::Cloud::CloudMutator, "#destroy eip_association" do

      it "destroys an elastic ip association" do
        eip_association
        result = mutator.destroy("test_eip_asso", eip_association_resource)
        verify_destroyed(result, "test_eip_asso", ElasticIPAssociation)
      end
    end
  end

  describe Harp::Cloud::CloudMutator, "#destroy instance" do
    include_context "when have an instance"

    it "destroys a cloud instance" do
      server_id
      result = mutator.destroy("test_inst1", instance_resource)
      verify_destroyed(result, "test_inst1", ComputeInstance)
    end
  end

  it "destroys a security group" do
    created = mutator.create("test_sg2", security_group_resource_2)
    result = mutator.destroy("test_sg2", security_group_resource_2)
    verify_destroyed(result, "test_sg2", SecurityGroup)
  end
  it "destroys a volume" do
    created = mutator.create("test_vol1", volume_resource)
    result = mutator.destroy("test_vol1", volume_resource)
    verify_destroyed(result, "test_vol1", Volume)
  end
end
