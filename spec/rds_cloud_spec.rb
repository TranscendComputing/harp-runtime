require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

db_security_group_resource = {
  "type" => "Std::DBSecurityGroup",
  "description" => "A web db security group"
}

describe Harp::Cloud::CloudMutator, "#create" do
  it "creates a db security group" do
    context = {}
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    mutator = Harp::Cloud::CloudMutator.new(context)

    result = mutator.create("test_db_sg1", db_security_group_resource)
    expect(result.class).to eq(DBSecurityGroup)
    expect(result.name).to eq("test_db_sg1")
    
    expect(result.description).to eq("A web db security group")
  end

end