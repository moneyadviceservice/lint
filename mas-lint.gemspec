# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mas/lint/version'

Gem::Specification.new do |spec|
  spec.name          = "mas-lint"
  spec.version       = Mas::Lint::VERSION
  spec.authors       = ["Yann"]
  spec.email         = ["yann.marquet@moneyadviceservice.org.uk"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sprockets-rails"
  spec.add_dependency "execcsslint"
  spec.add_dependency "execjslint"
  spec.add_dependency "rails"
  spec.add_dependency "colorize"
  spec.add_dependency "columnize"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec"
end
