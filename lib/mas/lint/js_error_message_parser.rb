module Mas
  module Lint
    class JsErrorMessageParser

      attr_reader :file

      def initialize(file)
        @file = file
      end

      def parse(raw_error)
        @raw_error = raw_error
        self
      end

      def type
        @raw_error['id'].gsub(/\(|\)/, '')
      end

      def line
        @raw_error['line']
      end

      def col
        @raw_error['character']
      end

      def message
        @raw_error['reason']
      end

      def evidence
        @raw_error['evidence']
      end
    end
  end
end
