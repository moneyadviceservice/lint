module Lint

  class Configuration
    attr_accessor :csslint_rules, :jshint_rules

    #TODO: eventually set sensible defaults
    def initialize
      @csslint_rules = {}
      @jshint_rules  = {}
    end
  end

  class Linter

    attr_reader :file

    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(self.configuration) if block_given?
    end

    def initialize(file, source = nil)
      @file    = file
      @source  = source
      @options = if file_extension == 'css'
        css_options             = self.class.configuration.csslint_rules.clone
        css_options['errors']   = (css_options['errors']   || []) if css_options.key?('errors')
        css_options['warnings'] = (css_options['warnings'] || []) if css_options.key?('warnings')
        css_options
      else
        self.class.configuration.jshint_rules
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
      when 'js', 'coffee' then 'JSHINTER'
      when 'css','scss'   then 'CSSLINTER'
      else
        raise ArgumentError, "Don't know the linter function to call for #{file_extension} file"
      end
    end

    def linter
      case file_extension
      when 'js', 'coffee' then JshintRuby
      when 'css', 'scss'  then CsslintRuby
      else
        raise ArgumentError, "Don't know how to lint #{file_extension} file"
      end
    end

    def parser
      case file_extension
      when 'js', 'coffee' then Lint::JsErrorMessageParser.new(file)
      when 'css', 'scss'  then Lint::CssErrorMessageParser.new(file)
      else
        raise ArgumentError, "Don't know how to parse linting errors for #{file_extension} file"
      end
    end

    def formater
      case file_extension
      when 'js', 'coffee'  then Lint::JsErrorFormater.new
      when 'css', 'scss'  then Lint::CssErrorFormater.new
      else
        raise ArgumentError, "Don't know how to formate linting errors for #{file_extension} file"
      end
    end

    def file_extension
      @file_extension ||= File.extname(@file).gsub('.', '')
    end

  end
end
