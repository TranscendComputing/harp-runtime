require 'data_mapper'
require 'harp-runtime/models/base'

# Result from command execution
class CopyResource < HarpResource

  def output?(args={})
    return false # TODO: capture output
  end

  def make_output_token(args={})
    self.output_token = "TODO: capture output"
  end

end

module Harp
  module Lang

    class Copy

      @@logger = Logging.logger[self]

      def initialize(interpreter, *attrs)
          @@logger.info "Init with attrs: #{attrs}"
          @interpreter = interpreter
          @args = attrs
      end

      def run()
          @@logger.info "Invoke copy..."
          copy = CopyResource.new()
          copy.id = "copy:#{CommandResource.auto_id}"
          copy.value = "#{@args}"
          copy          
      end

    end
  end
end