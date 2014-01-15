module Mas
  module Lint
    class Errors
      extend Forwardable

      def initialize(parser, formater)
        @_parser = parser
        @_errors = []
      end

      def empty?
        _errors.empty?
      end

      def parse!(result)
        @_errors = ErrorMessage.from_collection(result, _parser)
      end

      def full_messages
        _errors.map(&:to_message)
      end

      private

      def _parser
        @_parser
      end

      def _errors
        @_errors
      end
    end
  end
end
