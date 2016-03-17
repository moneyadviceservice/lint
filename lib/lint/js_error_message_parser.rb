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
      if !@raw_error['id'].nil?
        @raw_error['id'].gsub(/\(|\)/, '')
      else
        'error'
      end
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

    def hint
      # noop
    end

    def browsers
      # noop
    end

  end
end
