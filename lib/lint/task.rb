require 'sprockets/rails/task'

module Lint
  class CssLintError < SyntaxError; end
  class JsLintError < SyntaxError; end

  class Task < Sprockets::Rails::Task

     def define
       namespace :assets do
         desc 'Linting for css and Js files'
         task lint: :environment do
           with_logger do

             lintable_files  = manifest.files.select do |file, metadata|
               lintable?(metadata['logical_path'])
             end

             errors_messages = lintable_files.map do |file, _|
               Lint::Linter.new(File.open(File.join(manifest.dir, file)))
             end.reject(&:valid?).map(&:errors)

             errors_messages.each do |errors|
               STDOUT.puts errors.inspect
               Rails.application.assets.logger.fatal errors.full_messages.join("\n")

               # manifest.assets.logger.fatal errors.full_messages
             end
           end
         end
       end
     end

     private

     def lintable?(file)
        is_js_or_css?(file) && is_not_vendor_asset?(file)
     end

     def is_js_or_css?(file)
       ['.js', '.css'].include?(File.extname(file))
     end

     def is_not_vendor_asset?(file)
       manifest.environment.resolve(file).to_s.include?(Rails.root.join('app', 'assets').to_s)
     end
  end

end
