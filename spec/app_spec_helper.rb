# test env
require 'rspec'
require 'spec_helper'
require 'rack/test'
require 'rack/utils'
require 'sinatra'

# gems
require 'fog'
require 'database_cleaner'

# require the dependencies
require File.join(File.dirname(__FILE__), '..', 'app', 'init')
require File.join(File.dirname(__FILE__), '..', 'app', 'root')
require File.join(File.dirname(__FILE__), '..', 'app', 'api_base')
__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__)))

$LOAD_PATH.unshift __LIB_DIR__ unless
  $LOAD_PATH.include?(__LIB_DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__LIB_DIR__))

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

if ENV['RACK_ENV'] == 'production'
  # production config / requires
else
  # development or testing only
  #require 'pry'
  #require 'awesome_print'
  use Rack::ShowExceptions
end

# Database cleanup
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

# Constants
JSON_CONTENT = "application/json;charset=utf-8"
HTML_CONTENT = "text/html;charset=utf-8"
