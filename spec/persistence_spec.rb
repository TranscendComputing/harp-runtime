require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"

describe HarpResource, "persistence" do
	it "saves resources" do
    harp_script = ::HarpScript.first_or_new({:id => "test123"},
      {:location => "somewhere", :version => "1.0"})
    harp_script.content = "{'thing1':1}"
    harp_script.save

    harp_resource1 = ::ComputeInstance.new({:name=>"1",:state=>"starting",:type=>"ComputeInstance"})
    harp_resource1.save

    found_script = HarpScript.first_or_new({:id => "test123"})
    resources = found_script.harp_resources

  end
end
