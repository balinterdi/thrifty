class Expense
  include DataMapper::Resource
  
  property :id, Serial
  property :amount, Integer, :null => false
  
  belongs_to :event
  belongs_to :group
end