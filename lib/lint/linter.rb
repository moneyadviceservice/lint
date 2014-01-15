module Lint
  class Linter

    attr_reader :file

    def initialize(file, options = {})
      @file = file
      @options = if file_extension == 'css'
                   opts = {}
                   opts['errors']   = options['errors'].join(',')   if options.key?('errors')
                   opts['warnings'] = options['warnings'].join(',') if options.key?('warnings')
                   opts['ignore']   = options['ignore'].join(',')   if options.key?('ignore')
                   opts
                 else
                   options[file_extension] || {}
                 end
    end

    def valid?
      run!
      errors.empty?
    end

    def errors
      @errors ||= Errors.new(parser, formater)
    end

    private

    attr_reader :options

    def run!
      file.rewind
      result = linter.context.call(linter_function, file.read, options)
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
      when 'js'  then Lint::JsErrorMessageParser.new(file)
      when 'css' then Lint::CssErrorMessageParser.new(file)
      else
        raise ArgumentError, "Don't know how to parse linting errors for #{file_extension} file"
      end
    end

    def formater
      case file_extension
      when 'js'  then Lint::JsErrorFormater.new
      when 'css' then Lint::CssErrorFormater.new
      else
        raise ArgumentError, "Don't know how to formate linting errors for #{file_extension} file"
      end
    end

    def file_extension
      @file_extension ||= File.extname(@file).gsub('.', '')
    end
  end
end
