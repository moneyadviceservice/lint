module Lint
  class Linter

    attr_reader :file

    def initialize(file, options = {})
      @file = file
      @source = options[:source]
      @options = if file_extension == 'css'
                   opts = {}
                   opts['errors']   = options['errors'].join(',')   if options.key?('errors')
                   opts['warnings'] = options['warnings'].join(',') if options.key?('warnings')
                   opts['ignore']   = options['ignore'].join(',')   if options.key?('ignore')
                   opts['errors'] = 'important'
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
      result = linter.context.call(linter_function, @source || (file.rewind && file.read), options)
      errors.parse!(result.last)
    end

    def linter_function
      case file_extension
      when 'js'  then 'JSLINTR'
      when 'css', 'scss' then 'CSSLINTR'
      else
        raise ArgumentError, "Don't know the linter function to call for #{file_extension} file"
      end
    end

    def linter
      case file_extension
      when 'js'  then JSLint
      when 'css', 'scss' then CSSLint
      else
        raise ArgumentError, "Don't know how to lint #{file_extension} file"
      end
    end

    def parser
      case file_extension
      when 'js'  then Lint::JsErrorMessageParser.new(file)
      when 'css', 'scss' then Lint::CssErrorMessageParser.new(file)
      else
        raise ArgumentError, "Don't know how to parse linting errors for #{file_extension} file"
      end
    end

    def formater
      case file_extension
      when 'js'  then Lint::JsErrorFormater.new
      when 'css', 'scss' then Lint::CssErrorFormater.new
      else
        raise ArgumentError, "Don't know how to formate linting errors for #{file_extension} file"
      end
    end

    def file_extension
      @file_extension ||= File.extname(@file).gsub('.', '')
    end

  end
end
