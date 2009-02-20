class User
  include DataMapper::Resource
  
  property :id, Serial
  
  belongs_to :group
end