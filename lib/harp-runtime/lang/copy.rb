module Harp
  module Lang

    class Copy

      @@logger = Logging.logger[self]

      def initialize(interpreter, *attrs)
          @@logger.info "Init with attrs: #{attrs}"
          @interpreter = interpreter
      end

      def run()
          @@logger.info "Invoke copy..."
      end

    end
  end
end