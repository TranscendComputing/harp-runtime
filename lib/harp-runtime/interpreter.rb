# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2
require "shikashi"
require "logging"

module SandboxModule
  extend self

  DIE = "die"
  @interpreter = nil

  def set_engine(engine)
    @interpreter = engine
  end

  def engine()
    @interpreter
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

  def initialize
    @created = []
    @destroyed = []
    @updated = []
    @resourcer = Harp::Resourcer.new
  end

  # Accept the resources from a template and add to the dictionary of resources
  # available to the template.
  def consume(template)
    @resourcer.consume(template)
    return self
  end

  # Create a resource and wait for the resource to become available.
  def create(resource)
    @@logger.debug "Launching resource: #{resource}."
    @created.push(resource)
    return self
  end

  # Create a set of resources; all resources must will be complete before
  # processing continues.
  def createParallel(*resources)
    @@logger.debug "Launching resource(s) in parallel #{resources.join(',')}."
    @created += resources
    return self
  end

  # Update a resource to a new resource definition.
  def update(resource)
    @@logger.debug "Updating resource: #{resource}."
    @updated.push(resource)
    return self
  end

  # Update a set of resources in parallel to new resource definitions.
  def updateParallel(*resources)
    @@logger.debug "Updating resource(s) in parallel #{resources.join(',')}."
    @updated += resources
    return self
  end

  # Update a resource to an alternate definition.
  def updateTo(resource_start, resource_finish)
    @@logger.debug "Updating resource: #{resource_start} to #{resource_finish}."
    @updated.push(resource_finish)
    return self
  end

  # Destroy a named resource.
  def destroy(resource)
    @@logger.debug "Destroying resource: #{resource}."
    @destroyed.push resource
    return self
  end

  # Destroy a named resource.
  def destroyParallel(*resources)
    @@logger.debug "Destroying resource(s) in parallel #{resources.join(',')}."
    @destroyed += resources
    return self
  end

  def onFail(*fails)
    @@logger.debug "Handle fail action: #{fails.join(',')}"
    return self
  end

  def play(harp_file, lifecycle)

    file = File.open(harp_file, "rb")
    harp_contents = file.read

    s = Sandbox.new
    priv = Privileges.new
    priv.allow_method :print
    priv.allow_method :puts
    priv.allow_method :engine
    priv.allow_method :die

    priv.instances_of(HarpInterpreter).allow_all

    #SandboxModule.interpreter = self

    SandboxModule.set_engine(self)
    s.run(priv, harp_contents, :base_namespace => SandboxModule)

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

  def respond
    done = []
    @created.each do |createe|
      done.push "created #{createe}"
    end
    @updated.each do |updatee|
      done.push "updated #{updatee}"
    end
    @destroyed.each do |destroyee|
      done.push "destroyed #{destroyee}"
    end
    done
  end

end

end