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

autoscaling_policy_resource = {
  "type" => "Std::ScalingPolicy",
  "id" => "testScalingPolicy",
  "adjustment_type" => "PercentChangeInCapacity",
  "auto_scaling_group_name" => "testASG",
  "scaling_adjustment" => "0"
}

describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"

	it "creates a launch configuration" do
    result = mutator.create("test_lc1", launch_config_resource)
    expect(result.class).to eq(LaunchConfiguration)
    expect(result.name).to eq("test_lc1")
  end

  it "creates AS group" do
    result = mutator.create("test_as_group1", autoscaling_group_resource)
    expect(result.class).to eq(AutoScalingGroup)
    expect(result.name).to eq("test_as_group1")
  end

  it "creates AutoScaling Policy" do
    result = mutator.create("test_as_policy1", autoscaling_policy_resource)
    expect(result.class).to eq(ScalingPolicy)
    expect(result.name).to eq("test_as_policy1")
  end
end

describe Harp::Cloud::CloudMutator, "#destroy" do
  include_context "when have mutator"
  it "destroys launch configuration" do
    launch_config_resource["id"] = "testLC2"
    created = mutator.create("test_lc2", launch_config_resource)
    result = mutator.destroy("test_lc2", launch_config_resource)
    expect(result.class).to eq(LaunchConfiguration)
    expect(result.name).to eq("test_lc2")
  end

  it "destroys AS group" do
    autoscaling_group_resource["id"] = "testASG2"
    created = mutator.create("test_as_group2", autoscaling_group_resource)
    result = mutator.destroy("test_as_group2", autoscaling_group_resource)
    expect(result.class).to eq(AutoScalingGroup)
    expect(result.name).to eq("test_as_group2")
  end

  it "destroys AutoScaling Policy" do
    autoscaling_policy_resource["id"] = "testScalingPolicy2"
    created = mutator.create("test_as_policy2", autoscaling_policy_resource)
    result = mutator.destroy("test_as_policy2", autoscaling_policy_resource)
    expect(result.class).to eq(ScalingPolicy)
    expect(result.name).to eq("test_as_policy2")
  end
end
