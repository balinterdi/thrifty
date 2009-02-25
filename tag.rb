class Tag
  include DataMapper::Resource

  property :id, Serial

  has n, :taggings
  has n, :expenses, :through => :taggings
end