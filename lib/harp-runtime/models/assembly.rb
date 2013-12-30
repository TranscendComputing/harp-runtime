require 'data_mapper'
require 'harp-runtime/models/base'

class Assembly < HarpResource
  property :configuration_manager, String
end

class AssemblyChef < HarpResource
end

class AssemblyPuppet < HarpResource
end

class AssemblySalt < HarpResource
end