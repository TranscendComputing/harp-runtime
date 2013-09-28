$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'data_mapper'

DataMapper.setup(:default, "sqlite::memory:")

require 'harp-runtime/models/base'
require 'harp-runtime/models/compute'

DataMapper.finalize
DataMapper.auto_migrate!
