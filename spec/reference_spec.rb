require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "evalhook"

describe Harp::HarpInterpreter, "#play" do
  let(:ref_script) {
'template = <<END
{
  "Config": {
  },
  "Resources": {
    "lc1": {
      "type": "Std::LaunchConfiguration",
      "image_id": "ami-d0f89fb9",
      "instance_type": "t1.micro",
      "id": "langSpecLc"
    },
    "asg1": {
      "type": "Std::AutoScalingGroup",
      "id": "langSpecASG",
      "launch_configuration_name": {"ref": "lc1"},
      "availability_zones": "us-east-1",
      "max_size": "1",
      "min_size": "1"
    }

  }
}
END

engine.consume(template)

def create()
  engine.create("asg1")
end' }

  let(:interpreter_context) do
    c = create_interpreter_context()
    c[:harp_contents] = ref_script
    c
  end
  let(:interpreter) { Harp::HarpInterpreter.new(interpreter_context()) }
  it "handles refs" do
    results = interpreter.play("create", interpreter_context)
    expect(results).not_to be_empty
  end
end