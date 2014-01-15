module Mas
  class Railtie < ::Rails::Engine
    rake_tasks do |app|
      Mas::Lint::Task.new app
    end
  end
end
