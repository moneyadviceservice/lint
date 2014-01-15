module Lint
  class CssErrorMessageParser
    attr_reader :file
    def initialize(file)
      @file = file
    end

    def parse(raw_error)
      @raw_error = raw_error
      self
    end

    def type
      @raw_error['type']
    end

    def line
      @raw_error['line']
    end

    def col
      @raw_error['col']
    end

    def message
      @raw_error['message']
    end

    def evidence
      @raw_error['evidence']
    end

    def hint
      @raw_error['rule']['desc']
    end

    def browsers
      @raw_error['rule']['browsers']
    end
  end
end
