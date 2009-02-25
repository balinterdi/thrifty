class Tagging
  include DataMapper::Resource

  property :id, Serial

  belongs_to :expense
  belongs_to :tag

end