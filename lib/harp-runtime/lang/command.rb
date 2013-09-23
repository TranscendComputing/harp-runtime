module Harp
  module Lang

    class Command

      @@logger = Logging.logger[self]

      def initialize(interpreter, *attrs)
          @@logger.info "Init with attrs: #{attrs}"
          @interpreter = interpreter
      end

      def run()
          @@logger.info "Exec'ing command"
      end

    end
  end
end