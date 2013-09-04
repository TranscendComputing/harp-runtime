require "shikashi"
require "logging"
require "pry"

logger = Logging.logger['HarpInterpreter']
logger.add_appenders(Logging.appenders.stdout)
logger = Logging.logger['SandboxModule']
logger.add_appenders(Logging.appenders.stdout)

module SandboxModule
  extend self

  DIE = "die"
  @interpreter = nil

  def set_engine(engine)
    Logging.logger['SandboxModule'].debug "Setting engine"
    @interpreter = engine
  end

  def engine()
    Logging.logger['SandboxModule'].debug "Fetching engine"
    @interpreter
  end

  def die()
    return DIE
  end

  #def self.method_added(method_name)
  #  Logging.logger['SandboxModule'].debug "Adding #{method_name.inspect}"
  #end
end

class HarpInterpreter

  include Shikashi

  @@logger = Logging.logger[self]

  def initialize
    @created = []
    @destroyed = []
  end

  def engine
    @@logger.info "Engine call"
    return self
  end

  def consume(template)
    # TODO: handle URL
    @@logger.info "Consume template: #{template.length.to_s}"
    return self
  end

  def create(resource)
    @@logger.debug "Launching resource: #{resource}."
    @created.push(resource)
    return self
  end

  def createParallel(res1, res2)
    resources = [res1, res2]
    @@logger.debug "Launching resource(s) in parallel #{resources.join(',')}."
    @created += resources
    @@logger.debug "Returning #{self.inspect}."
    return self
  end

  def update(resource)
    @@logger.debug "Updating resource: #{resource}."
    @created.push(resource)
    return self
  end

  def updateParallel(*resources)
    @@logger.debug "Updating resource(s) in parallel #{resources.join(',')}."
    @created += resources
    return self
  end

  def destroy(resource)
    @@logger.debug "Destroying resource: #{resource}."
    @destroyed.push resource
    return self
  end

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

    priv.instances_of(HarpInterpreter).allow :create, :createParallel
    priv.instances_of(HarpInterpreter).allow :update, :updateParallel
    priv.instances_of(HarpInterpreter).allow :destroy, :destroyParallel
    priv.instances_of(HarpInterpreter).allow :consume
    priv.instances_of(HarpInterpreter).allow :onFail
    priv.instances_of(HarpInterpreter).allow :die

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
    @destroyed.each do |destroyee|
      done.push "destroyed #{destroyee}"
    end
    done
  end

end

