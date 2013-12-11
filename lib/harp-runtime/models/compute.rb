require 'data_mapper'
require 'harp-runtime/models/base'

# A single virtual machine
class ComputeInstance < HarpResource
  property :key_name, String
  property :image_id, String
  property :public_ip_address, String
  property :private_ip_address, String
end

class ElasticIP < HarpResource
  property :public_ip_address, String
end

class ElasticIPAssociation < HarpResource
end

class NetworkInterface < HarpResource
end

class SecurityGroup < HarpResource
end

class Subnet < HarpResource
end

class Volume < HarpResource
end

class Vpc < HarpResource
end

class InternetGateway < HarpResource
end

class VpcGatewayAttachment < HarpResource
end

class DhcpOption < HarpResource
end

class DhcpOptionAssociation < HarpResource
end

class RouteTable < HarpResource
end

class Route < HarpResource
end

class SecurityGroupIngress < HarpResource
end
