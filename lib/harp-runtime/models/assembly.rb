require 'data_mapper'
require 'harp-runtime/models/base'

# Assembly is the datastore representation of a Harp Assembly resource.
class Assembly < HarpResource
  property :configuration_manager, String
end

# AssemblyChef is the datastore representation of a Harp Assembly with Chef.
class AssemblyChef < HarpResource
  property :public_ip_address, String
  property :private_ip_address, String
end

# AssemblyPuppet is the datastore representation of an Assembly with Puppet.
class AssemblyPuppet < HarpResource
  property :public_ip_address, String
  property :private_ip_address, String
end

# AssemblySalt is the datastore representation of an Assembly with Salt.
class AssemblySalt < HarpResource
  property :public_ip_address, String
  property :private_ip_address, String
end

# AssemblyDocker is the datastore representation of an Assembly with Docker.
class AssemblyDocker < HarpResource
end