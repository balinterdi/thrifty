class User
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :null => false
  property :login, String, :min_length => 4
  property :password, String, :min_length => 4
  
  belongs_to :group
  has n, :expenses
  
  def self.authenticate(user, password)
    self.first(:login => user, :password => password)
  end
  
  def sum_expenses_for_tag(tag)
    expenses.select do |exp|
      exp.tags.map { |t| t.name }.include?(tag)
    end.
      inject(0) { |sum, exp| sum + exp.amount }
  end
  
end