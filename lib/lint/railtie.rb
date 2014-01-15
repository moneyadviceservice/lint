module Lint
  class Railtie < ::Rails::Engine
    rake_tasks do |app|
      Lint::Task.new app
    end
  end
end
