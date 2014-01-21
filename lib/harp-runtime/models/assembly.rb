require 'data_mapper'
require 'harp-runtime/models/base'

class Assembly < HarpResource
  property :configuration_manager, String
end

class AssemblyChef < HarpResource
  property :public_ip_address, String
  property :private_ip_address, String
end

class AssemblyPuppet < HarpResource
end

class AssemblySalt < HarpResource
end