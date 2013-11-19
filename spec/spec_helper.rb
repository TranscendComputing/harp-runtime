$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'data_mapper'

DataMapper.setup(:default, "sqlite::memory:")

require 'harp-runtime/models/base'
require 'harp-runtime/models/compute'

DataMapper.finalize
DataMapper.auto_migrate!
