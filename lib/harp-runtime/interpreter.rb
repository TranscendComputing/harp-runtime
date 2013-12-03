# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2
require "shikashi"
require "harp-runtime/cloud/cloud_mutator"
require "harp-runtime/lang/command"
require "harp-runtime/lang/copy"

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
  attr_accessor :mutator

  include Shikashi

  @@logger = Logging.logger[self]

  def initialize(context)
    @events = []
    @resourcer = Harp::Resourcer.new(context[:harp_id])
    @mutator = Harp::Cloud::CloudMutator.new(context)
    @program_counter = 0
    @current_line = 1
    @is_debug = (context.include? :debug) ? true : false
    @break_at = (context.include? :break) ? context[:break].to_i : 0
    @continue = (context.include? :continue) ? true : false
    @events.push ({ :nav => "[Mock mode]" }) if (context.include? :mock)
    if (context.include? :step)
      @desired_pc = context[:step][/.*l:\d+:pc:(\d+).*$/, 1].to_i + 1
    elsif (context.include? :continue)
      @desired_pc = context[:continue][/.*l:\d+:pc:(\d+).*$/, 1].to_i + 1
    else
      @desired_pc = nil
    end
  end

  # Accept the resources from a template and add to the dictionary of resources
  # available to the template.
  def consume(template)
    # Consume is always performed, otherwise resources aren't available.
    @resourcer.consume(template)
    return self
  end

  # Create a resource and wait for the resource to become available.
  def create(resource_name)
    if ! advance() then return self end
    @@logger.debug "Launching resource: #{resource_name}."
    resource = @resourcer.get resource_name
    #Iterate over values to check for refs
    resource.each do |key, value|
        if value.is_a?(Hash)
            create(value["ref"])
            resource[key] = "testLC"
        end
    end

    created = @mutator.create(resource_name, resource)
    created.harp_script = @harp_script
    result = {:create => resource_name}
    args = {:action => :create}
    if created.output? (args)
      result[:output] = created.make_output_token(args)
      result[:line] = @current_line
    end
    @events.push(result)
    created.save
    return self
  end

  # Create a set of resources; all resources must will be complete before
  # processing continues.
  def createParallel(*resources)
    if ! advance() then return self end
    @@logger.debug "Launching resource(s) in parallel #{resources.join(',')}."
    resources.each do |resource|
      resource = @resourcer.get resource_name
      created = @mutator.create(resource_name, resource)
      created.harp_script = @harp_script
      result = {:create => resource_name}
      args = {:action => :create}
      if created.output? (args)
        result[:output] = created.make_output_token(args)
        result[:line] = @current_line
      end
      @events.push(result)
      created.save
    end
    return self
  end

  # Update a resource to a new resource definition.
  def update(resource_name)
    if ! advance() then return self end
    @@logger.debug "Updating resource: #{resource_name}."
    @events.push({ :update => resource_name})
    return self
  end

  # Update a set of resources in parallel to new resource definitions.
  def updateParallel(*resources)
    if ! advance() then return self end
    @@logger.debug "Updating resource(s) in parallel #{resources.join(',')}."
    resources.each { |resource| @events.push( { :update => resource })}
    return self
  end

  # Update a resource to an alternate definition.
  def updateTo(resource_start, resource_finish)
    if ! advance() then return self end
    @@logger.debug "Updating resource: #{resource_start} to #{resource_finish}."
    @events.push({ :update => resource_name})
    return self
  end

  # Destroy a named resource.
  def destroy(resource_name)
    if ! advance() then return self end
    @@logger.debug "Destroying resource: #{resource_name}."
    result = {:destroy => resource_name}
    args = {:action => :destroy}
    resource = @resourcer.get_existing(resource_name)
    destroyed = @mutator.destroy(resource_name, resource)
    destroyed.harp_script = @harp_script
    if destroyed.output? (args)
      result[:output] = destroyed.make_output_token(args)
      result[:line] = @current_line
    end
    @events.push(result)
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
    SandboxModule::set_break
    @break_at = SandboxModule::line_count
    return self
  end

  def parse(content)

    sandbox = Sandbox.new
    priv = Privileges.new
    priv.allow_method :print
    priv.allow_method :puts
    priv.allow_method :engine
    priv.allow_method :line_mark
    priv.allow_method :die
    priv.allow_method :breakpoint

    priv.instances_of(HarpInterpreter).allow_all

    SandboxModule.set_engine(self)

    sandbox.run(priv, content, :base_namespace => SandboxModule)
  end

  def load_harp(harp_file, harp_contents, harp_id)
    if harp_file != nil
      file = File.open(harp_file, "rb")
      harp_contents = file.read
      harp_location = "file:///#{harp_file}"
    else
      harp_location = "inline"
    end
    @harp_script = ::HarpScript.first_or_new({:id => harp_id},
      {:location => harp_location, :version => "1.0"})
    if !@harp_script.saved?
      @harp_script.content = harp_contents
      @harp_script.save
    end
  end

  def play(lifecycle, options)

    harp_file = options[:harp_file] || nil

    if lifecycle.to_sym == Harp::Lifecycle::CREATE
      options[:harp_id] = SecureRandom.urlsafe_base64(16)
    end

    load_harp(harp_file, options[:harp_contents], options[:harp_id])

    # Now, instrument the script for debugging.
    harp_contents = parse(instrument_for_debug(@harp_script.content))

    @events.push({ :harp_id => options[:harp_id]})

    # Call create/delete etc., as defined in harp file
    if SandboxModule.method_defined? lifecycle
      @@logger.debug "Invoking lifecycle: #{lifecycle.inspect}."
      SandboxModule.method(lifecycle).call()
    else
      raise "No lifecycle method #{lifecycle.inspect} defined in harp."
    end

    respond
  end

  def reconnect_existing(harp_id)
    @harp_script = ::HarpScript.get(harp_id)

    @events.push({ :harp_id => harp_id})

    parse(@harp_script.content)
    resources = @harp_script.harp_resources
  end

  def get_output(output_token, options)
    resources = reconnect_existing(options[:harp_id])
    found = resources.select {|resource| resource.output_token == output_token}
    if found
      persisted = found[0]
      resource = @resourcer.get(persisted.name)
      output = @mutator.get_output(resource, persisted)
      @events.push({ :output => output })
    end
    respond
  end

  def get_status(options)
    resources = reconnect_existing(options[:harp_id])

    respond
  end

  def method_missing(meth, *args, &block)
    if ! advance() then return self end
    @@logger.debug "Invoking: #{meth}"
    begin
      require "harp-runtime/lang/#{meth}"
      instruction = Harp::Lang.const_get("#{meth}".camel_case()).new(self, args)
      run_result = instruction.run()
      run_result.harp_script = @harp_script
      result = {meth => meth}
      if run_result.output?
        result[:output] = run_result.make_output_token(args)
        result[:line] = @current_line
      end
      @events.push(result)
      run_result.save
    rescue => e
      @@logger.debug "Unable to invoke: #{meth}", e
    end
  end

  private

  def respond
    done = @events
    if @is_debug && @break_at > 0
      done.push ({ "token" => "l:#{@current_line}:pc:#{@program_counter}" })
      done.push ({ "break" => "Break at line #{@break_at}" })
    else
      done.push ({ "end" => "Harp played successfully." })
    end
    done
  end

  # Advance the program counter to the next instruction.
  def advance
    @@logger.debug "At line: #{SandboxModule::line_count}, #{caller[0][/`.*'/][1..-2]}"
    if @break_at > 0
      @@logger.debug "Waiting for l:#{@break_at}, at l:#{SandboxModule::line_count}"
      if @break_at <= SandboxModule::line_count
        return false
      end
    end
    @program_counter += 1
    @current_line = SandboxModule::line_count
    if @desired_pc && @program_counter < @desired_pc
      @@logger.debug "Waiting for pc:#{@desired_pc}, at pc:#{@program_counter}"
      return false
    end
    if @desired_pc && @program_counter == @desired_pc
      @@logger.debug "Reached desired pc #{@desired_pc} at #{@current_line} #{SandboxModule::line_count}"
      if @continue
        @desired_pc = nil
      else
        @break_at = @current_line
      end
    end
    return true
  end

  # Decorate script with line number tags, to enable line number tracking for breakpoints.
  def instrument_for_debug harp_contents
    if ! @is_debug
      return harp_contents
    end
    new_harp, line_count, in_here_doc = "", 0, false
    harp_contents.each_line do |line|
      line_count += 1
      if not in_here_doc
        new_harp << "line_mark(#{line_count})\n#{line}"
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
