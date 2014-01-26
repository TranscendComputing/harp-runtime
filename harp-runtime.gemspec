# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'harp-runtime/version'

Gem::Specification.new do |gem|
  gem.authors       = ["John Gardner"]
  gem.email         = ["jgardner@transcendcomputing.com"]
  gem.description   = %q{Spins up infrastructure and services across clouds.}
  gem.summary       = %q{Harp includes both a language for specifying orchestrations and runtime to invoke the language.}
  gem.homepage      = "http://www.transcendcomputing.com"
  gem.license       = "ASLV2"


  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "harp-runtime"
  gem.require_paths = ["lib"]
  gem.version       = Harp::Runtime::VERSION

  gem.add_runtime_dependency "sinatra"
  gem.add_runtime_dependency "sinatra-contrib"
  gem.add_runtime_dependency "shikashi"
  gem.add_runtime_dependency "datamapper"
  gem.add_runtime_dependency "logging"
  gem.add_runtime_dependency "fog"
  gem.add_runtime_dependency "rgl"
  gem.add_runtime_dependency "json"
  gem.add_runtime_dependency "extlib"
  gem.add_runtime_dependency "dm-mysql-adapter"
  gem.add_runtime_dependency "dm-sqlite-adapter"
  gem.add_runtime_dependency "net-ssh"
  gem.add_runtime_dependency "puma"
  gem.add_runtime_dependency "delayed_job"
  gem.add_runtime_dependency "delayed_job_data_mapper"
  gem.add_runtime_dependency "faraday",["= 0.8.9"]
  gem.add_runtime_dependency "ridley"
  gem.add_runtime_dependency "ridley-connectors"
  gem.add_runtime_dependency "httparty"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "shotgun"
  gem.add_development_dependency "racksh"
  gem.add_development_dependency "pry-debugger"
  gem.add_development_dependency "awesome_print"
  gem.add_development_dependency "source2swagger"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "dm-sqlite-adapter"
  gem.add_development_dependency "coveralls"
  gem.add_development_dependency "flog"
end
