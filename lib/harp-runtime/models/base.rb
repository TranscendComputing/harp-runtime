# Represents a harp script.
class HarpScript
  include DataMapper::Resource
  property :id, String, :key => true

  property :location, String, :length => 255, :required => true 
  property :version, String, :required => true 

  has n, :harp_resources
  has n, :harp_plays, :through => Resource 
end

# Represents a single execution of a Harp script.
class HarpPlay
  include DataMapper::Resource
  property :id, Serial

  property :location, String, :length => 255, :required => true 
  property :played_at, DateTime
  property :status, String

  # a Harp play may consist of multiple scripts, through composition
  has n, :harp_scripts, :through => Resource 
  has n, :harp_resources, :through => :harp_scripts
end

# An atomic unit to create/destroy.
class HarpResource
  attr_accessor :live_resource

  include DataMapper::Resource
  property :id, String, :key => true

  property :name, String
  property :state, String
  property :type, Discriminator
  property :output_token, String

  belongs_to :harp_script

  @live_resource

  def output?(args={})
    return live_resource.output_token(args)
  end

  def make_output_token(args={})
    self.output_token = live_resource.output_token(args)
  end

end