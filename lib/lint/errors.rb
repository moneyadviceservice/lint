module Lint
  class Errors

    def initialize(parser, formater)
      @parser   = parser
      @formater = formater
      @errors   = []
    end

    def empty?
      errors.empty?
    end

    def parse!(result)
      @errors = ErrorMessage.from_collection(result, parser)
    end

    def full_messages
      formater.format(errors)
    end

    private

    def parser
      @parser
    end

    def formater
      @formater
    end

    def errors
      @errors.select(&:is_error?)
    end

  end
end
