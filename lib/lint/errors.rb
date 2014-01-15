module Lint
  class Errors

    def initialize(parser, formater)
      @_parser   = parser
      @_formater = formater
      @_errors   = []
    end

    def empty?
      _errors.empty?
    end

    def parse!(result)
      @_errors = ErrorMessage.from_collection(result, _parser)
    end

    def full_messages
      _formater.format(_errors)
    end

    private

    def _parser
      @_parser
    end

    def _formater
      @_formater
    end

    def _errors
      @_errors.select(&:is_error?)
    end
  end
end
