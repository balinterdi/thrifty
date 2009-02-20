class Group
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :null => false
  property :login, String, :min_length => 4
  property :password, String, :min_length => 4
  
  has n, :users
end