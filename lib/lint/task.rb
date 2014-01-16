module Lint
  class CssLintError < SyntaxError; end
  class JsLintError < SyntaxError; end

  class Task < Sprockets::Rails::Task
    def define
      namespace :assets do
        desc 'Linting for css and Js files'
        task lint: :environment do
          with_logger do
            require 'byebug'

            errors_messages = manifest.files.map do |file, _|
              Lint::Linter.new(File.open(File.join(manifest.dir, file)))
            end.reject(&:valid?).map(&:errors)

            errors_messages.each do |errors|
              Rails.application.assets.logger.fatal errors.full_messages.join("\n")

              # manifest.assets.logger.fatal errors.full_messages
            end
          end
        end
      end
    end

  end

end
