module Mas
  module Lint
    class ErrorMessage
      attr_reader :type, :line, :col, :message, :evidence, :hint, :browsers, :file_path

      def self.from_collection(collection, parser)
        collection.map { |e| new(parser.parse(e)) }
      end

      def initialize(parser)
        @file_path = File.absolute_path(parser.file)
        @type      = parser.type
        @line      = parser.line
        @col       = parser.col
        @message   = parser.message
        @evidence  = parser.evidence
        @hint      = parser.hint
        @browsers  = parser.browsers
      end
    end
  end
end
