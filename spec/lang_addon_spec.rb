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
    },
    "lc1": {
      "type": "Std::LaunchConfiguration",
      "image_id": "ami-d0f89fb9",
      "instance_type": "t1.micro",
      "id": "testLC"
    },
    "asg1": {
      "type": "Std::AutoScalingGroup",
      "id": "testASG",
      "launch_configuration_name": {"ref": "lc1"},
      "availability_zones": "us-east-1",
      "max_size": "1",
      "min_size": "1"
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

def create()
  engine.create("asg1")
end

OUTER

describe Harp::HarpInterpreter, "#play" do
  let(:interpreter_context) do
    c = create_interpreter_context()
    c[:harp_contents] = ADDON_SCRIPT
    c
  end
  let(:interpreter) { Harp::HarpInterpreter.new(interpreter_context()) }

  it "handles refs" do
    results = interpreter.play("create", interpreter_context)
    expect(results).not_to be_empty
  end

end
