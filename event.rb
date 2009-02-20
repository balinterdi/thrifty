class Event
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :null => false
  
  has 1, :pot
  has n, :expenses
  
  has n, :participants
  has n, :groups, :through => :participants
end