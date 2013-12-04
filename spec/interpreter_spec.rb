require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"
require "evalhook"

describe Harp::HarpInterpreter do

  describe '#play' do
    let(:interpreter_context) do
      c = create_interpreter_context()
      c[:harp_contents] = VALID_SCRIPT
      c
    end
    let(:interpreter) {
      Harp::HarpInterpreter.new(interpreter_context())
    }

    def find_break_event(results)
      expect(results).not_to be_empty
      #results.each do |result|  puts result end
      breakpoint = 0
      break_event = nil
      results.each do |result|
        break_event = result["break"] if result.include? ("break")
      end
      puts "No break event in #{results}" if not break_event
      break_event
    end

    it "instruments for debug" do
      results = interpreter.play("create", interpreter_context)
      break_event = find_break_event(results)
      break_event.should match ".*32$" # Should have broken at line 32
    end

    context 'when in debug mode with breakpoint' do

      let(:breakpoint_context) do
        c = interpreter_context()
        # 38 happens to be a reasonable breakpoint in VALID_SCRIPT
        c[:break] = 38
        c
      end
      let(:interpreter) {
        Harp::HarpInterpreter.new(breakpoint_context())
      }

      it "instruments for debug and accepts breakpoint" do
        results = interpreter.play("destroy", breakpoint_context)
        break_event = find_break_event(results)
        break_event.should match ".*38$" # Should have broken at line 38
      end
    end

    it "invokes custom lifecycles" do
      results = interpreter.play("custom", interpreter_context)
      expect(results).not_to be_empty
      destroyed = nil
      results.each do |result|
        destroyed = result[:destroy] if result.include? (:destroy)
      end
      destroyed.should match "computeInstance2" # Custom lifecycle should have destroyed this
    end
  end
end
