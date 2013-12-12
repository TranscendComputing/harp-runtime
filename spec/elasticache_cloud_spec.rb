require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

security_group_resource = {
  "type" => "Std::SecurityGroup",
  "name" => "web-security-group",
  "description" => "A web security group"
}

cache_security_group_resource = {
  "type" => "Std::CacheSecurityGroup",
  "id" => "cache-security-group",
  "description" => "A cache security group"
}

cache_security_group_ingress_resource = {
  "type" => "Std::CacheSecurityGroupIngress",
  "group_name" => "cache-security-group",
  "ec2_name" => ""
}

shared_context 'when have a cache security_group' do
  let(:security_group) do
    @new_security_group = mutator.create("test_security_group_1", security_group_resource)
    @new_security_group.instance_variable_get(:@name)
  end
  let(:cache_security_group) do
    @new_cache_security_group = mutator.create("test_cache_security_group_1", cache_security_group_resource)
    @new_cache_security_group.instance_variable_get(:@id)
  end
  let(:cache_security_group_ingress) do
    cache_security_group_ingress_resource['ec2_name'] = security_group
    cache_security_group_ingress_resource['group_name'] = cache_security_group
    @new_cache_security_group_ingress = mutator.create("test_cache_security_group_ingress1", cache_security_group_ingress_resource)
    @new_cache_security_group_ingress.instance_variable_get(:@id)
  end
end

describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"
  include_context "when have a cache security_group"
  it "creates a cache security group" do
    cache_security_group_resource['id'] = 'cache-security-group-2'
    cache_security_group
    verify_created(@new_cache_security_group, "test_cache_security_group_1", CacheSecurityGroup)
  end
  it "creates a cache_security_group_ingress" do
    cache_security_group_resource['id'] = 'cache-security-group-3'
    cache_security_group_ingress
    verify_created(@new_cache_security_group_ingress, "test_cache_security_group_ingress1", CacheSecurityGroupIngress)
  end
end

describe Harp::Cloud::CloudMutator, "#destroy" do
  include_context "when have mutator"
  include_context "when have a cache security_group"
	it "destroys a cache security group" do
    cache_security_group_resource['id'] = 'cache-security-group-4'
    cache_security_group
    result = mutator.destroy("test_cache_security_group_1", cache_security_group_resource)
    verify_destroyed(result, "test_cache_security_group_1", CacheSecurityGroup)
  end
  #fog states this action is: to-do
  # it "destroys a cache_security_group_ingress" do
#     cache_security_group_ingress
#     result = mutator.destroy("test_cache_security_group_ingress1", cache_security_group_ingress_resource)
#     verify_destroyed(result, "test_cache_security_group_ingress1", CacheSecurityGroupIngress)
#   end
end