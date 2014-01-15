module Lint
  class CssLintError < SyntaxError; end
  class JsLintError < SyntaxError; end

  class Task < Sprockets::Rails::Task
    def define
      super
      namespace :assets do
        desc 'Linting for css and Js files'
        task lint: :environment do
          with_logger do

            css_file = manifest.files.keys.select do |file|
              File.extname(file) == '.css'
            end

            js_file = manifest.files.keys.select do |file|
              File.extname(file) == '.js'
            end

            css_file.each do |f|
              css = File.open(File.join(output, 'public', f))
              linter = Css.new(css)
              raise CssLintError.new(linter.errors.join("\n")) unless linter.valid?
            end

            js_file.each do |f|
              js = File.open(File.join(output, 'public', f))
              linter = Js.new(js)
              raise JsLintError.new(linter.errors.join("\n")) unless linter.valid?
            end

          end
        end
      end
    end

  end

end
