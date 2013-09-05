# -*- encoding: utf-8 -*-
require File.expand_path('../lib/harp-runtime/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John Gardner"]
  gem.email         = ["jgardner@transcendcomputing.com"]
  gem.description   = %q{Spins up infrastructure and services across clouds.}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "harp-runtime"
  gem.require_paths = ["lib"]
  gem.version       = Harp::Runtime::VERSION

  gem.add_runtime_dependency "sinatra"
  gem.add_runtime_dependency "shikashi"
  gem.add_runtime_dependency "datamapper"
  gem.add_runtime_dependency "logging"
  gem.add_runtime_dependency "fog"
  gem.add_runtime_dependency "logging"
  gem.add_runtime_dependency "rgl"
  gem.add_runtime_dependency "evalhook", '> 0.5.2'

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "shotgun"
  gem.add_development_dependency "racksh"
  gem.add_development_dependency "pry-debugger"
  gem.add_development_dependency "source2swagger"

end
