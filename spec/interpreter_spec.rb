require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/harp_runtime'

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
  engine.break
  engine.create("computeInstance3")
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

  end
end