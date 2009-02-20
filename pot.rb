class Pot
  include DataMapper::Resource
  
  # property :id, Serial
  belongs_to :event
end