require 'rails'
require 'mas/lint/version'
require 'sprockets/rails/task'
require 'execcsslint'
require 'execjslint'
require 'columnize'
require 'mas/lint/task'
require 'mas/lint/css_error_message_parser'
require 'mas/lint/js_error_message_parser'
require 'mas/lint/css_error_formater'
require 'mas/lint/js_error_formater'
require 'mas/lint/error_message'
require 'mas/lint/errors'
require 'mas/lint/linter'

module Mas
  module Lint
    class Railtie < ::Rails::Engine
      rake_tasks do |app|
        Mas::Lint::Task.new app
      end
    end
  end
end
