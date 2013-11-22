require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "evalhook"

ADDON_SCRIPT = <<OUTER
template = <<END
{
  "Config": {
  },
  "Resources": {
    "computeInstance1": {
      "type": "Std::ComputeInstance",
      "imageId": "ami-d0f89fb9",
      "instanceType": "t1.micro"
    }
  }
}
END

engine.consume(template)

def command()
  engine.command("computeInstance1", "service apache2 restart")
end

def copy()
  engine.copy("computeInstance1", "path1", "path2")
end

OUTER

describe Harp::HarpInterpreter, "#play" do

  before :each do
    @context = {}
    @context[:cloud_type] = :aws # for the moment, assume AWS cloud
    @context[:mock] = true
    @context[:debug] = true
    @context[:access] = "test"
    @context[:secret] = "test"
  end

  it "handles commands" do
    interpreter = Harp::HarpInterpreter.new(@context)

    @context[:harp_contents] = ADDON_SCRIPT
    results = interpreter.play("command", @context)
    expect(results).not_to be_empty
  end

  it "handles copies" do
    interpreter = Harp::HarpInterpreter.new(@context)

    @context[:harp_contents] = ADDON_SCRIPT
    results = interpreter.play("copy", @context)
    expect(results).not_to be_empty
  end
end
