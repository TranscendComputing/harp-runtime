require 'data_mapper'
require 'harp-runtime/models/base'

# Result from command execution
class CommandResource < HarpResource

  def output?(args={})
    return false # TODO: capture output
  end

  def make_output_token(args={})
    self.output_token = "TODO: capture output"
  end

end

module Harp
  module Lang

    class Command

      @@logger = Logging.logger[self]

      def initialize(interpreter, *attrs)
          @@logger.info "Init with attrs: #{attrs}"
          @interpreter = interpreter
          @args = attrs
      end

      def run()
          @@logger.info "Exec'ing command"
          command = CommandResource.new()
          command.id = "command:#{CommandResource.auto_id}"
          command.value = "#{@args}"
          command
      end

    end
  end
end