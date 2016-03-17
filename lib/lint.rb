require 'rails'
require 'tilt'
require 'lint/version'
require 'sprockets/server'
require 'sprockets/rails/task'
require 'csslint_ruby'
require 'jshint_ruby'
require 'lint/task'
require 'lint/css_error_message_parser'
require 'lint/js_error_message_parser'
require 'lint/css_error_formater'
require 'lint/js_error_formater'
require 'lint/error_message'
require 'lint/errors'
require 'lint/linter'

module Lint

  class AssetLinter < Tilt::Template

    def self.engine_initialized?
      defined?(::Lint::Linter)
    end

    def initialize_engine
      require_template_library 'lint'
    end

    def prepare
      # noop
    end

    def evaluate(context, locals, &block)
      return data if is_vendor_assets?

      linter = linter_klass.new(file, data)
      return data if linter.valid?

      raise StandardError.new(linter.errors.full_messages.join("\n"))
    end

    private

    def linter_klass
      Lint::Linter
    end

    def is_vendor_assets?
      !!(file.match(/vendor/))
    end
  end

  class JSLinter < AssetLinter
    self.default_mime_type = 'application/javascript'

    private
    def linter_klass
      Lint::Js
    end
  end

  class CSSLinter < AssetLinter
    self.default_mime_type = 'text/css'

    private
    def linter_klass
      Lint::Css
    end
  end


  class Railtie < ::Rails::Engine

    isolate_namespace Lint

    initializer 'lint.rack_middleware', group: :all do |app|
      app.assets.register_engine '.js', Lint::JSLinter
      app.assets.register_engine '.css', Lint::CSSLinter
    end

    rake_tasks do |app|
      Lint::Task.new app
    end
  end

end
