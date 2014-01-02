require 'data_mapper'
require 'harp-runtime/models/base'

# Assembly is the datastore representation of a Harp Assembly resource.
class Assembly < HarpResource
  property :configuration_manager, String
end

# AssemblyChef is the datastore representation of a Harp Assembly with Chef.
class AssemblyChef < HarpResource
end

# AssemblyPuppet is the datastore representation of an Assembly with Puppet.
class AssemblyPuppet < HarpResource
end

# AssemblySalt is the datastore representation of an Assembly with Salt.
class AssemblySalt < HarpResource
end

# AssemblyDocker is the datastore representation of an Assembly with Docker.
class AssemblyDocker < HarpResource
end
