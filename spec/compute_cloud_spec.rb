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

network_interface_resource = {
  "type"            => "Std::NetworkInterface",
  "sourceDestCheck" => "false",
  "groupSet"        => ["sg-75zzz219"],
  "privateIpAddress"=> "10.0.0.16"
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

subnet_resource = {
  "type"       => "Std::Subnet",
  "cidrBlock"  => "10.0.0.0/24",
  "availabilityZone" => "us-east-1a",
  "vpcId"      => "vpc-903w8odf9"
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

shared_context 'when have a network interface' do
  let(:subnet) do
    @new_subnet = mutator.create("test_sbnt1", subnet_resource)
    @new_subnet.instance_variable_get(:@id)
  end
  let(:network_interface) do
    network_interface_resource["subnet_id"] = subnet

    @network_interface = mutator.create("test_netwIn1", network_interface_resource)
    @network_interface.instance_variable_get(:@id)
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

  describe Harp::Cloud::CloudMutator, "#create network_interface" do
    include_context "when have a network interface"

    it "creates a subnet" do
      #TODO, remove hardwired vpc once VPC resource is added
      subnet
      verify_created(@new_subnet, "test_sbnt1", Subnet)
    end

    it "creates a network interface" do
      subnet
      network_interface
      verify_created(@network_interface, "test_netwIn1", NetworkInterface)
    end

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

#Destroy specs
describe Harp::Cloud::CloudMutator, "#destroy" do
  include_context "when have mutator"


  describe Harp::Cloud::CloudMutator, "#destroy network_interface" do
    include_context "when have a network interface"

    it "destroys a subnet" do
      #TODO, remove hardwired vpc once VPC resource is added
      subnet
      result = mutator.destroy("test_sbnt1", subnet_resource)
      verify_destroyed(result, "test_sbnt1", Subnet)
    end

    it "destroys a network interface" do
      network_interface
      result = mutator.destroy("test_netwIn1", network_interface_resource)
      verify_destroyed(result, "test_netwIn1", NetworkInterface)
    end
  end

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
