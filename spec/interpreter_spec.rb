require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "evalhook"

# A sample script

script = <<OUTER
# Create some instances on AWS

template = <<END
{
  "Config": {
  },
  "Resources": {
    "computeInstance1": {
      "type": "Std::ComputeInstance",
      "imageId": "ami-d0f89fb9",
      "instanceType": "t1.micro"
    },
    "computeInstance2": {
      "type": "Std::ComputeInstance",
      "imageId": "ami-d0f89fb9",
      "instanceType": "t1.micro"
    },
    "computeInstance3": {
      "type": "Std::ComputeInstance",
      "imageId": "ami-d0f89fb9",
      "instanceType": "t1.micro"
    }
  }
}
END

engine.consume(template)

def create()
  engine.create("computeInstance1")
  engine.create("computeInstance2")
  engine.break # should be line 32, from top of script
  engine.create("computeInstance3")
end

def destroy()
  engine.destroy("computeInstance1")
  engine.destroy("computeInstance3")
end

def custom()
  engine.destroy("computeInstance2")
end

OUTER

describe Harp::HarpInterpreter, "#play" do
	it "instruments for debug" do
		context = {}
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    interpreter = Harp::HarpInterpreter.new(context)

    context[:harp_contents] = script
    results = interpreter.play("create", context)
    expect(results).not_to be_empty
    #results.each do |result|  puts result end
    breakpoint = 0
    break_event = nil
    results.each do |result|
      break_event = result["break"] if result.include? ("break")
    end
    break_event.should match ".*32$" # Should have broken at line 32

  end

  it "instruments for debug and accepts breakpoint" do
    context = {}
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    context[:break] = 38
    interpreter = Harp::HarpInterpreter.new(context)

    context[:harp_contents] = script
    results = interpreter.play("destroy", context)
    expect(results).not_to be_empty
    breakpoint = 0
    break_event = nil
    results.each do |result|
      break_event = result["break"] if result.include? ("break")
    end
    break_event.should match ".*38$" # Should have broken at line 38

  end

  it "invokes custom lifecycles" do
    context = {}
    context[:cloud_type] = :aws
    context[:mock] = true
    context[:debug] = true
    context[:access] = "test"
    context[:secret] = "test"
    interpreter = Harp::HarpInterpreter.new(context)

    context[:harp_contents] = script
    results = interpreter.play("custom", context)
    expect(results).not_to be_empty
    destroyed = nil
    results.each do |result|
      destroyed = result[:destroy] if result.include? (:destroy)
    end
    destroyed.should match "computeInstance2" # Custom lifecycle should have destroyed this
  end

end