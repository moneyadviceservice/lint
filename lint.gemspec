# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lint/version'

Gem::Specification.new do |spec|
  spec.name          = "lint"
  spec.version       = Lint::VERSION
  spec.authors       = ["StupidCodeFactory"]
  spec.email         = ["ymarquet@gmail.com"]
  spec.description   = %q{Programmatically lint your css and js files}
  spec.summary       = %q{lint gem aims at providing a comviniante way of using JSLint and CSSLint from within your ruby application}
  spec.homepage      = "https://github.com/moneyadviceservice/lint"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "execcsslint"
  spec.add_dependency "execjslint"
  spec.add_dependency "rails"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec"
end
