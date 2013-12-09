require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "harp-runtime/cloud/cloud_mutator"

elastic_application_resource = {
  "type" => "Std::ElasticApplication"
}

elastic_environment_resource = {
  "type" => "Std::ElasticEnvironment"
}

#Fog does not support mock run for Beanstalk
describe Harp::Cloud::CloudMutator, "#create" do
  include_context "when have mutator"

	it "creates elastic application" do
    pending "Mock not implemented for ElasticApplication"
    result = mutator.create("test_el_app", elastic_application_resource)
    expect(result.class).to eq(ElasticApplication)
    expect(result.name).to eq("test_el_app")
  end

  it "creates elastic environment" do
    pending "Mock not implemented for ElasticEnvironment"
    result = mutator.create("test_el_env", elastic_environment_resource)
    expect(result.class).to eq(ElasticEnvironment)
    expect(result.name).to eq("test_el_env")
  end


end