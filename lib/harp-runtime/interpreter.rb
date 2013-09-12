# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2
require "shikashi"
require "harp-runtime/cloud/cloud_mutator"

module SandboxModule
  extend self

  DIE = "die"
  @interpreter = nil
  @line_count = 0
  @breakpoint = false

  def set_engine(engine)
    @interpreter = engine
  end

  def engine()
    @interpreter
  end

  def line_mark(line)
    @line_count = line unless @breakpoint
  end

  def line_count()
    @line_count
  end

  def at_breakpoint?
    @breakpoint
  end

  def set_break()
    @breakpoint = true
  end

  def breakpoint()
    @interpreter.break
  end

  def die()
    return DIE
  end

  def self.method_added(method_name)
    Logging.logger['SandboxModule'].debug "Adding #{method_name.inspect}"
  end
end

module Harp
# The interpreter reads in the template, and makes itself available as engine()
# with the scope of the template.  All resource operations are proxied through
# this object.
class HarpInterpreter

  include Shikashi

  @@logger = Logging.logger[self]

  def initialize(context)
    @events = []
    @resourcer = Harp::Resourcer.new
    @mutator = Harp::Cloud::CloudMutator.new(context)
    @program_counter = 0
    @is_debug = (context.include? :debug) ? true : false
    @break_at = (context.include? :break) ? context[:break] : nil
    @events.push ({ :nav => "[Mock mode]" }) if (context.include? :mock)

  end

  # Accept the resources from a template and add to the dictionary of resources
  # available to the template.
  def consume(template)
    if ! advance() then return self end
    @resourcer.consume(template)
    return self
  end

  # Create a resource and wait for the resource to become available.
  def create(resource_name)
    if ! advance() then return self end
    @@logger.debug "Launching resource: #{resource_name}."
    resource = @resourcer.get resource_name
    @mutator.create(resource_name, resource)
    @events.push({ "create" => resource_name})
    return self
  end

  # Create a set of resources; all resources must will be complete before
  # processing continues.
  def createParallel(*resources)
    if ! advance() then return self end
    @@logger.debug "Launching resource(s) in parallel #{resources.join(',')}."
    resources.each do |resource| @events.push( { "create" => resource }) end
    return self
  end

  # Update a resource to a new resource definition.
  def update(resource_name)
    if ! advance() then return self end
    @@logger.debug "Updating resource: #{resource_name}."
    @events.push({ "update" => resource_name})
    return self
  end

  # Update a set of resources in parallel to new resource definitions.
  def updateParallel(*resources)
    if ! advance() then return self end
    @@logger.debug "Updating resource(s) in parallel #{resources.join(',')}."
    resources.each { |resource| @events.push( { "update" => resource })}
    return self
  end

  # Update a resource to an alternate definition.
  def updateTo(resource_start, resource_finish)
    if ! advance() then return self end
    @@logger.debug "Updating resource: #{resource_start} to #{resource_finish}."
    @events.push({ "update" => resource_name})
    return self
  end

  # Destroy a named resource.
  def destroy(resource_name)
    if ! advance() then return self end
    @@logger.debug "Destroying resource: #{resource_name}."
    @events.push({ "destroy" => resource_name})
    return self
  end

  # Destroy a named resource.
  def destroyParallel(*resources)
    if ! advance() then return self end
    @@logger.debug "Destroying resource(s) in parallel #{resources.join(',')}."
    resources.each { |resource| @events.push( { "destroy" => resource })}
    return self
  end

  def onFail(*fails)
    if ! advance() then return self end
    @@logger.debug "Handle fail action: #{fails.join(',')}"
    return self
  end

  # Interpreter debug operation; break at current line.
  def break
    if ! advance() then return self end
    @@logger.debug "Handle break."
    @events.push({ "break" => "Break at line #{SandboxModule::line_count}"})
    SandboxModule::set_break
    @break_at = SandboxModule::line_count
    return self
  end

  # Interpreter debug operation; continue running from a break.
  def continue
    if ! advance() then return self end
    @@logger.debug "Handle continue."
    @events.push({ "continue" => "Continue at line #{SandboxModule::line_count}"})
    @break_at = nil
    return self
  end

  # Interpreter debug operation; step over a single operation.
  def step
    if ! advance() then return self end
    @@logger.debug "Handle step."
    @events.push({ "step" => "Step at line #{SandboxModule::line_count}"})
    @break_at += 1
    return self
  end

  def play(lifecycle, options)

    harp_file = options[:harp_file] || nil
    harp_contents = options[:harp_contents] || nil

    if harp_file != nil
      file = File.open(harp_file, "rb")
      harp_contents = file.read
    end
    harp_contents = instrument_for_debug harp_contents

    s = Sandbox.new
    priv = Privileges.new
    priv.allow_method :print
    priv.allow_method :puts
    priv.allow_method :engine
    priv.allow_method :line_mark
    priv.allow_method :die
    priv.allow_method :breakpoint

    priv.instances_of(HarpInterpreter).allow_all

    SandboxModule.set_engine(self)
    s.run(priv, harp_contents, :base_namespace => SandboxModule)

    # Now, instrument the script for debugging.

    # Call create/delete etc., as defined in harp file
    if SandboxModule.method_defined? lifecycle
      @@logger.debug "Invoking lifecycle: #{lifecycle.inspect}."
      @@logger.debug "Invoking: #{SandboxModule.method(lifecycle)}."
      SandboxModule.method(lifecycle).call()
    else
      raise "No lifecycle method #{lifecycle.inspect} defined in harp."
    end

    respond
  end

  private

  def respond
    done = @events
    if @is_debug
      done.push ({ "token" => "l:#{SandboxModule::line_count}:pc:#{@program_counter}" })
    end
    done
  end

  # Advance the program counter to the next instruction.
  def advance
    if ! @break_at.nil?
      if @break_at >= SandboxModule::line_count
        return false
      end
    end
    @@logger.debug "At line: #{SandboxModule::line_count}, #{caller[0][/`.*'/][1..-2]}" 
    @program_counter += 1
    return true
  end

  # Decorate script with line number tags, to enable breakpoints.
  def instrument_for_debug harp_contents
    if ! @is_debug 
      return harp_contents
    end
    new_harp, line_count, in_here_doc = "", 0, false
    harp_contents.each_line do |line|
      line_count += 1
      if not in_here_doc
        new_harp << "line_mark(#{line_count});#{line}"
        in_here_doc = line[/.*\w+\s*=\s*<<-*([\w]+)/, 1]
      else
        new_harp << line        
        if line[/^#{in_here_doc}/] 
          in_here_doc = false
        end
      end
    end
    new_harp
  end

end

end