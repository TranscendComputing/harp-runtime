$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'simplecov'
require 'coveralls'
require 'factory_girl'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  minimum_coverage 80
end

require 'data_mapper'

DataMapper.setup(:default, "sqlite::memory:")

require 'harp-runtime/models/base'
require 'harp-runtime/models/compute'
require 'harp-runtime/models/rds'

DataMapper.finalize
DataMapper.auto_migrate!

# A sample script

VALID_SCRIPT = <<OUTER
# Create some instances on AWS

template = <<END
{
  "Config": {
  },
  "Resources": {
    "computeInstance1": {
      "type": "Std::ComputeInstance",
      "imageId": "ami-d0f89fb9",
      "instanceType": "t1.micro"
    },
    "computeInstance2": {
      "type": "Std::ComputeInstance",
      "imageId": "ami-d0f89fb9",
      "instanceType": "t1.micro"
    },
    "computeInstance3": {
      "type": "Std::ComputeInstance",
      "imageId": "ami-d0f89fb9",
      "instanceType": "t1.micro"
    }
  }
}
END

engine.consume(template)

def create()
  engine.create("computeInstance1")
  engine.create("computeInstance2")
  engine.break # should be line 32, from top of script
  engine.create("computeInstance3")
end

def destroy()
  engine.destroy("computeInstance1")
  engine.destroy("computeInstance3")
end

def custom()
  engine.destroy("computeInstance2")
end

OUTER

# Tell Factory Girl to load the factory definitions, now that we've required everything (unless they have already been loaded)
FactoryGirl.find_definitions
