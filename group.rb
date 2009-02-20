class Group
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :null => false
  property :login, String, :min_length => 4
  property :password, String, :min_length => 4

  has n, :users

  def self.current_group=(group)
    session["current_user"] = group.id
  end

  def self.current_group
    session["current_group"]
  end

  def self.authenticate(user, password)
    group = Group.first(:login => user, :password => password)
    current_group = group
  end
end