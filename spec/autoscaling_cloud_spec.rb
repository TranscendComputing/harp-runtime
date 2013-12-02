require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

launch_config_resource = {
  "type" => "Std::LaunchConfiguration",
  "image_id" => "ami-d0f89fb9",
  "instance_type" => "t1.micro",
  "id" => "testLC"
}

autoscaling_group_resource = {
  "type" => "Std::AutoScalingGroup",
  "id" => "testASG",
  "launch_configuration_name" => "testLC",
  "availability_zones" => "us-east-1",
  "max_size" => "1",
  "min_size" => "1"
}

describe Harp::Cloud::CloudMutator, "#create" do
	it "creates a launch configuration" do
		context = {}
    context[:cloud_type] = :aws # for the moment, ainstancessume AWS cloud
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    mutator = Harp::Cloud::CloudMutator.new(context)

    result = mutator.create("test_lc1", launch_config_resource)
    expect(result.class).to eq(LaunchConfiguration)
    expect(result.name).to eq("test_lc1")
  end

  it "creates AS group" do
    context = {}
    context[:cloud_type] = :aws # for the moment, ainstancessume AWS cloud
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    mutator = Harp::Cloud::CloudMutator.new(context)

    result = mutator.create("test_as_group1", autoscaling_group_resource)
    expect(result.class).to eq(AutoScalingGroup)
    expect(result.name).to eq("test_as_group1")
  end
end