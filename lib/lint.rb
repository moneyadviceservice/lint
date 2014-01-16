require 'rails'
require 'lint/version'
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
  class Railtie < ::Rails::Engine
    rake_tasks do |app|
      Lint::Task.new app
      Rake::Task['assets:precompile'].enhance do
        Rake::Task['assets:lint'].invoke
      end
    end
  end
end
