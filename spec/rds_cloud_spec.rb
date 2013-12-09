require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

db_security_group_resource = {
  "type" => "Std::DBSecurityGroup",
  "description" => "A web db security group"
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
    # context = {}
#     context[:cloud_type] = :aws # for the moment, assume AWS cloud
#     context[:mock] = true
#     context[:debug] = true
#     context[:access] = "test"
#     context[:secret] = "test"
    #mutator = Harp::Cloud::CloudMutator.new(context)

    result = mutator.create("test_db_sg1", db_security_group_resource)
    expect(result.class).to eq(DBSecurityGroup)
    expect(result.name).to eq("test_db_sg1")
    
    expect(result.description).to eq("A web db security group")
  end
  it "creates a db instance" do
    # context = {}
#     context[:cloud_type] = :aws # for the moment, assume AWS cloud
#     context[:mock] = true
#     context[:debug] = true
#     context[:access] = "test"
#     context[:secret] = "test"
    #mutator = Harp::Cloud::CloudMutator.new(context)

    result = mutator.create("test_db_db1", db_instance_resource)
    expect(result.class).to eq(DBInstance)
    expect(result.name).to eq("test_db_db1")
  end
end