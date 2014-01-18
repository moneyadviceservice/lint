require 'rails'
require 'tilt'
require 'lint/version'
require 'sprockets/server'
require 'sprockets/rails/task'
require 'execcsslint'
require 'execjslint'
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
      # Rails.logger.info @code.inspect
      # Rails.logger.info data.inspect
      return data if is_vendor_assets?

      Rails.logger.info self.inspect
      linter = Lint::Linter.new(file, source: data)
      return data if linter.valid?

      raise StandardError.new(linter.errors.full_messages.join("\n"))
    end

    private

    def is_vendor_assets?
      !!(file.match(/vendor/))
    end
  end

  class JSLinter < AssetLinter
    self.default_mime_type = 'application/javascript'
  end

  class CSSLinter < AssetLinter
    self.default_mime_type = 'text/css'
  end

  class RackMiddleware

    include Sprockets::Server

    def initialize(app, assets)
      @app           = app
      @assets        = assets
    end

    def call(env)

      status, headers, response = @app.call(env)
      path = unescape(env['PATH_INFO'].to_s.sub(/^\//, ''))

      return [status, headers, response] unless path.present?

      if asset = path_for_asset(path)

        return [ status, headers, response ] if is_vendor?(asset)
        Rails.logger.info response.inspect
        linter = Lint::Linter.new(virutal_for_asset(asset, path), source: response.body)
        return [ status, headers, response ] if linter.valid?

        if File.extname(virutal_for_asset(asset, path)) == '.css'
          e = StandardError.new("Asset compilation error")
          e.set_backtrace(linter.errors.full_messages)

          return css_exception_response(e)
        else
          e = StandardError.new(linter.errors.full_messages.join("\n"))
          return javascript_exception_response(e)
        end
      else
        [ status, headers, response ]
      end
    end

    private
    attr_reader :assets

    def path_for_asset(path)
      assets.find_asset(Pathname.new(path).basename)
    end

    def virutal_for_asset(asset, path)
      asset.pathname.split.first.join(path)
    end

    def is_vendor?(asset)
      !asset.pathname.to_s.match(Regexp.new(Rails.root.join('app', 'assets').to_s))
    end
  end


  class Railtie < ::Rails::Engine

    isolate_namespace Lint

    initializer 'lint.rack_middleware', group: :all do |app|
      app.middleware.use Lint::RackMiddleware, app.assets

      #   byebug
      #   Sprockets.register_postprocessor 'application/javascript', Lint::JSLinter
      # app.assets.register_postprocessor 'text/css', Lint::CSSLinter
      #   Sprockets.register_engine '.js', Lint::JSLinter
      # app.assets.register_engine '.css', Lint::CSSLinter
      # end
      # require 'byebug'
      # byebug

      # config.assets.configure do |env|
      #   env.register_postprocessor 'application/javascript', Lint::JSLinter
      #   env.register_postprocessor 'text/css', Lint::CSSLinter
      #   # env.register_engine '.js', Lint::JSLinter
      #   # env.register_engine '.css', Lint::CSSLinter
      #   env.logger = Rails.logger

    end

    rake_tasks do |app|
      Lint::Task.new app
    end
  end

end
