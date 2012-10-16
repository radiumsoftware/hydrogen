# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hydrogen/version'

Gem::Specification.new do |gem|
  gem.name          = "hydrogen"
  gem.version       = Hydrogen::VERSION
  gem.authors       = ["Adam Hawkins"]
  gem.email         = ["me@broadcastingadam.com"]
  gem.description   = %q{Framework for building extendable Ruby application}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/radiumsoftware/hydrogen"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "thor"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "mocha"
end
