$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'simplecov'
require 'coveralls'
require 'factory_girl'

# For debugging.
#require 'logging'
#Logging.logger.root.add_appenders(Logging.appenders.stdout)
#Logging.logger.root.level = :debug

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

require 'harp-runtime/models/autoscale'
require 'harp-runtime/models/base'
require 'harp-runtime/models/user_data'
require 'harp-runtime/models/compute'
require 'harp-runtime/models/rds'
require 'harp-runtime/models/elastic_load_balancing'
require 'harp-runtime/models/elasticache'
require 'harp-runtime/models/assembly'

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
    },
    "computeInstance4": {
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
  engine.break # should be line 37, from top of script
  engine.create("computeInstance3")
end

def destroy()
  engine.destroy("computeInstance1")
  engine.destroy("computeInstance3")
end

def custom()
  engine.create("computeInstance4")
end

OUTER

module SpecHelpers
  def create_interpreter_context
    interpreter_context = {}
    interpreter_context[:cloud_type] = :aws # for the moment, assume AWS cloud
    interpreter_context[:mock] = true
    interpreter_context[:debug] = true
    interpreter_context[:access] = "test"
    interpreter_context[:secret] = "test"
    interpreter_context[:harp_script] = FactoryGirl.create(:harp_script)
    interpreter_context
  end
end

RSpec.configure do |c|
  c.include SpecHelpers
end

shared_context 'when have mutator' do
  let(:mutator) { Harp::Cloud::CloudMutator.new(create_interpreter_context()) }
  def verify_created(result, name, type)
    expect(result.class).to eq(type)
    expect(result.name).to eq(name)
    expect(result.state).to eq(Harp::Resources::AvailableResource::CREATED)
  end
  def verify_destroyed(result, name, type)
    expect(result.class).to eq(type)
    expect(result.name).to eq(name)
    expect(result.state).to eq(Harp::Resources::AvailableResource::DESTROYED)
  end
end

# Tell Factory Girl to load the factory definitions, now that we've required everything (unless they have already been loaded)
FactoryGirl.find_definitions
