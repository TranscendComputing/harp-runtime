require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

lb_load_balancer_resource = {
  "type" => "Std::LoadBalancer",
  "listeners" => [{'Protocol'=>'HTTP','LoadBalancerPort'=>80,'InstancePort'=>80,'InstanceProtocol'=>'HTTP'}]
}

describe Harp::Cloud::CloudMutator, "#create" do
  it "creates a loadbalancer" do
    context = {}
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    mutator = Harp::Cloud::CloudMutator.new(context)

    result = mutator.create("test_lb_lb1", lb_load_balancer_resource)
    expect(result.class).to eq(LoadBalancer)
    expect(result.name).to eq("test_lb_lb1")
  end
end