require 'data_mapper'
require 'harp-runtime/models/base'

# A single virtual machine
class ComputeInstance < HarpResource
  property :key_name, String
  property :image_id, String
  property :public_ip_address, String
  property :private_ip_address, String
end