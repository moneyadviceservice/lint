module Mas
  module Lint
    class Linter

      attr_reader :file

      def initialize(file)
        @file = file
      end

      def valid?
        run!
        errors.empty?
      end

      def errors
        @errors ||= Errors.new(parser, formater)
      end

      private

      def run!
        file.rewind
        result = linter.context.call(linter_function, file.read, {})
        puts result.inspect
        errors.parse!(result.last)
      end

      def linter_function
        case file_extension
        when 'js'  then 'JSLINTR'
        when 'css' then 'CSSLINTR'
        else
          raise ArgumentError, "Don't know the linter function to call for #{file_extension} file"
        end
      end

      def linter
        case file_extension
        when 'js'  then JSLint
        when 'css' then CSSLint
        else
          raise ArgumentError, "Don't know how to lint #{file_extension} file"
        end
      end

      def parser
        case file_extension
        when 'js'  then Mas::Lint::JsErrorMessageParser.new(file)
        when 'css' then Mas::Lint::CssErrorMessageParser.new(file)
        else
          raise ArgumentError, "Don't know how to parse linting errors for #{file_extension} file"
        end
      end

      def formater
        # raise NoMethodError, "Must implement: #{self.class}#formater"
      end

      def file_extension
        @file_extension ||= File.extname(@file).gsub('.', '')
      end
    end
  end
end
