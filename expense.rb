class Expense
  include DataMapper::Resource

  property :id, Serial
  property :amount, Integer, :null => false

  has n, :taggings
  has n, :tags, :through => :taggings

  # an expense _can_ belong to an event if it is a shared expense
  belongs_to :event
  # an expense always belongs to a user; the one who paid
  belongs_to :user
end