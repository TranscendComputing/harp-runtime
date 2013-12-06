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
    let(:interpreter_context_created) do
      c = create_interpreter_context()
      c[:harp_contents] = VALID_SCRIPT
      c[:harp_id] = '123123'
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
      break_event.should match ".*37$" # Should have broken at line 37
    end

    context 'when in debug mode with breakpoint' do

      let(:breakpoint_context) do
        c = interpreter_context()
        # 42 happens to be a reasonable breakpoint in VALID_SCRIPT
        c[:break] = 42
        c
      end
      let(:interpreter) {
        Harp::HarpInterpreter.new(breakpoint_context())
      }

      it "instruments for debug and accepts breakpoint" do
        interpreter.play("create", breakpoint_context)
        results = interpreter.play("destroy", breakpoint_context)
        break_event = find_break_event(results)
        require 'awesome_print'
        ap results
        break_event.should match ".*42$" # Should have broken at line 42
      end
    end

    it "invokes custom lifecycles" do
      harp_script = FactoryGirl.create(:harp_script)
      interpreter_context_created = interpreter_context.clone
      interpreter_context_created[:harp_id] = harp_script.id
      results = interpreter.play("custom", interpreter_context_created)
      expect(results).not_to be_empty
      destroyed = nil
      results.each do |result|
        destroyed = result[:create] if result.include? (:create)
      end
      destroyed.should match "computeInstance4" # Custom lifecycle should have destroyed this
    end
  end
end
