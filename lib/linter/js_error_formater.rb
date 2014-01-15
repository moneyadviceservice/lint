module Linter

  class JsErrorFormater

    def format(errors)
      errors.map do |error|
        [ file_line_col(error), evidence(error), message(error), hint(error)].compact.join("\n")
      end
    end

    private
    def file_line_col(error)
      [error.file_path, error.line, error.col].join(':')
    end

    def message(error)
      "Error: #{error.message}"
    end

    def evidence(error)
      "\t#{error.evidence}"
    end

    def hint(error)
      "Hint: #{error.hint}" unless error.hint.nil?
    end
  end

end
