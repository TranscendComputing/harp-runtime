require 'harp-runtime/models/base'

# Represents a harp user.
class HarpUser
  include DataMapper::Resource
  property :id, Serial, :key => true

  property :name, String

  has n, :harp_scripts, :through => Resource
  has n, :keys, :through => Resource
end

class Key
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :key => true
  property :value, Text

  has n, :harp_users, :through => Resource

  def temp_file
    t = Tempfile.new(name)
    t << value
    t.close
    t
  end
  def self.get_by_name(key_name)
    Key.all(:name => key_name).first
  end
end
