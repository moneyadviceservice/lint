module Lint

  class Configuration
    attr_accessor :csslint_rules, :jshint_rules
    attr_reader   :css_file_extensions, :js_file_extensions

    def initialize
      @csslint_rules       = {}
      @jshint_rules        = {}
      @css_file_extensions = []
      @js_file_extensions  = []
    end
  end

  class Linter

    CSS_EXTENSIONS = ['.css', '.scss', '.sass', '.less']
    JS_EXTENSIONS  = ['.js', '.coffee']

    attr_reader :file

    class << self
      attr_accessor :configuration

      def configure
        self.configuration ||= Configuration.new
        yield(self.configuration) if block_given?
      end

      def for(file)
        basename = File.basename(file)
        return Css.new(file) if is_css?(basename)
        return Js.new(file)  if is_js?(basename)
      end

      private

      def is_css?(filename)
        !!available_css_extensions.detect {|ext| filename.match(Regexp.escape(ext)) }
      end

      def is_js?(filename)
        !!available_js_extensions.detect {|ext| filename.match(Regexp.escape(ext)) }
      end

      def available_css_extensions
        CSS_EXTENSIONS + configuration.css_file_extensions
      end

      def available_js_extensions
        JS_EXTENSIONS + configuration.js_file_extensions
      end
    end

    def initialize(file, source = nil)
      @file    = file
      @source  = source
      @options = {}
    end

    def valid?
      run!
      errors.empty?
    end

    def errors
      @errors ||= Errors.new(parser, formater)
    end

    def linter_function
      raise NoMethodError.new("#{self.class} must implement #linter_function")
    end

    def linter
      raise NoMethodError.new("#{self.class} must implement #linter")
    end

    def parser
      raise NoMethodError.new("#{self.class} must implement #parser")
    end

    def formater
      raise NoMethodError.new("#{self.class} must implement #formater")
    end


    private

    attr_reader :options

    def run!
      # Rails.logger.info options
      result = linter.context.call(linter_function, @source || (file.rewind && file.read), options)
      errors.parse!(result.last)
    end

    def file_extension
      @file_extension ||= File.extname(@file).gsub('.', '')
    end


  end

  class Css < Linter
    def initialize(*args)
      super
      @options = Lint::Linter.configuration.csslint_rules
    end

    def linter_function
      'CSSLINTER'
    end

    def linter
      CsslintRuby
    end

    def parser
      Lint::CssErrorMessageParser.new(file)
    end

    def formater
      Lint::CssErrorFormater.new
    end

  end

  class Js < Linter
    def initialize(*args)
      super
      @options = Lint::Linter.configuration.jshint_rules
    end

    def linter_function
      'JSHINTER'
    end

    def linter
      JshintRuby
    end

    def parser
      Lint::JsErrorMessageParser.new(file)
    end

    def formater
      Lint::JsErrorFormater.new
    end
  end


end
