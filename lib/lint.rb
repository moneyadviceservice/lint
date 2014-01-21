require 'rails'
require 'tilt'
require 'lint/version'
require 'sprockets/server'
require 'sprockets/rails/task'
require 'execcsslint'
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

  class RackMiddleware

    include Sprockets::Server

    def initialize(app, assets)
      @app           = app
      @assets        = assets
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      status, headers, response = @app.call(env)
      path = unescape(env['PATH_INFO'].to_s.sub(/^\//, ''))

      return [status, headers, response] unless path.present?

      if asset = path_for_asset(path, env)
        return not_modified_response(asset, env) if etag_match?(asset, env)
        return [ status, headers, response ]     if is_vendor?(asset)
        return [ status, headers, response ]     if !['.js', '.css'].include?(File.extname(asset.logical_path))

        linter = Lint::Linter.new(virutal_for_asset(asset, path), response.body)
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

    def path_for_asset(path, env)
      assets.find_asset(Pathname.new(path).basename, bundle: !body_only?(env))
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
      app.middleware.use(Lint::RackMiddleware, app.assets)
    end

    rake_tasks do |app|
      Lint::Task.new app
    end
  end

end

Lint::Linter.configure
