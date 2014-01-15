module Linter

  class CssErrorFormater

    def format(errors)
      errors.map do |error|
        [ file_line_col(error), evidence(error), message(error), hint(error), browsers(error)].join("\n")
      end
    end

    private
    def file_line_col(error)
      [error.file_path, error.line, error.col].join(':')
    end

    def browsers(error)
      "Affected browsers: #{error.browsers}"
    end

    def message(error)
      "#{error.type.capitalize}: #{error.message}"
    end

    def evidence(error)
      "\t#{error.evidence}"
    end

    def hint(error)
      "Hint: #{error.hint}"
    end
  end

end
