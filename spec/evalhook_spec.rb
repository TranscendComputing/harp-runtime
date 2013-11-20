require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "shikashi"

include Shikashi

module Sandboxer
  extend self

  attr_accessor :line_count

  @line_count = 0

  def add_to_count()
    @line_count += 1 
  end

end

describe Shikashi, "sandbox" do
  it "runs script in sandbox" do
  sandbox = Sandbox.new
  priv = Privileges.new
  priv.allow_method :puts
  priv.allow_method :add_to_count

  priv.instances_of(Sandboxer).allow_all

  sandbox.run(priv, '
  def go()
    add_to_count()
    add_to_count()
  end', :base_namespace => Sandboxer)

  Sandboxer.method("go").call()
  Sandboxer.line_count.should eq(2)
  end
end
