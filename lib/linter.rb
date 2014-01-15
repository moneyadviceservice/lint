require 'rails'
require 'lint/version'
require 'sprockets/rails/task'
require 'execcsslint'
require 'execjslint'
require 'linter/task'
require 'linter/css_error_message_parser'
require 'linter/js_error_message_parser'
require 'linter/css_error_formater'
require 'linter/js_error_formater'
require 'linter/error_message'
require 'linter/errors'
require 'linter/linter'

module Linter
  class Railtie < ::Rails::Engine
    rake_tasks do |app|
      Linter::Task.new app
    end
  end
end
