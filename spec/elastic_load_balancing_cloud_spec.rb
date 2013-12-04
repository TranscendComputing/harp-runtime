require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"

lb_load_balancer_resource = {
  "type" => "Std::LoadBalancer",
  "listeners" => [{'Protocol'=>'HTTP','LoadBalancerPort'=>80,'InstancePort'=>80,'InstanceProtocol'=>'HTTP'}]
}

describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"

  it "creates a loadbalancer" do
    result = mutator.create("test_lb_lb1", lb_load_balancer_resource)
    expect(result.class).to eq(LoadBalancer)
    expect(result.name).to eq("test_lb_lb1")
  end
end
