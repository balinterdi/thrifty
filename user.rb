class User
  include DataMapper::Resource

  attr_accessor :password, :password_confirmation

  property :id, Serial
  property :name, String, :null => false
  property :login, String, :min_length => 4
  property :encrypted_password, String
  property :salt, String

  before :save, :encrypt_password

  belongs_to :group
  has n, :expenses

  class << self
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("#{password}+#{salt}")
    end
  end

  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("#{Time.now.to_s}+login") if new_record?
    self.encrypted_password = encrypt(password)
  end

  def self.authenticate(login, password)
    user = User.first(:login => login)
    user && user.encrypt(password) == user.encrypted_password ? user : nil
  end

  def sum_expenses_for_tag(tag)
    expenses.select do |exp|
      exp.tags.map { |t| t.name }.include?(tag)
    end.
      inject(0) { |sum, exp| sum + exp.amount }
  end

  def get_expenses_with_tags(tags)
    # this should be elegant like this, but it does not work
    expenses.select do |exp|
      exp.tagged_with?(*tags)
    end
  end

end