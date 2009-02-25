class Group
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  
  has n, :users
  has n, :events

end