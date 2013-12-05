require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "evalhook"

describe Harp::HarpInterpreter, "#play" do
  let(:addon_script) {
'template = <<END
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
end' }

  let(:interpreter_context) do
    c = create_interpreter_context()
    c[:harp_contents] = addon_script
    c
  end
  let(:interpreter) { Harp::HarpInterpreter.new(interpreter_context()) }

  it "handles commands" do
    results = interpreter.play("command", interpreter_context)
    expect(results).not_to be_empty
  end

  it "handles copies" do
    results = interpreter.play("copy", interpreter_context)
    expect(results).not_to be_empty
  end
end