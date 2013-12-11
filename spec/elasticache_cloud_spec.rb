require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

security_group_resource = {
  "type" => "Std::SecurityGroup",
  "name" => "web-security-group",
  "description" => "A web security group"
}

db_instance_resource = {
  "type" => "Std::DBInstance",
  "engine" => "MySQL",
  "allocated_storage" => "5",
  "master_username" => "masterdbusername",
  "password" => "masterpassword"
}

describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"
  it "creates a db security group" do
    result = mutator.create("test_db_sg1", db_security_group_resource)
    expect(result.class).to eq(DBSecurityGroup)
    expect(result.name).to eq("test_db_sg1")
    expect(result.description).to eq("A web db security group")
  end
  it "creates a db instance" do
    result = mutator.create("test_db_db1", db_instance_resource)
    expect(result.class).to eq(DBInstance)
    expect(result.name).to eq("test_db_db1")
  end
end

describe Harp::Cloud::CloudMutator, "#destroy" do
  include_context "when have mutator"
	it "destroys a db security group" do
    created = mutator.create("test_db_sg2", db_security_group_resource)
    result = mutator.destroy("test_db_sg2", db_security_group_resource)
    expect(result.class).to eq(DBSecurityGroup)
    expect(result.name).to eq("test_db_sg2")
  end
	it "destroys a db instance" do
    created = mutator.create("test_db_db2", db_instance_resource)
    result = mutator.destroy("test_db_db2", db_instance_resource)
    expect(result.class).to eq(DBInstance)
    expect(result.name).to eq("test_db_db2")
  end
end