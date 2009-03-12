class Expense
  include DataMapper::Resource

  property :id, Serial
  property :amount, Integer, :null => false
  property :subject, String
  property :spent_at, Date

  has n, :taggings
  has n, :tags, :through => :taggings

  # an expense _can_ belong to an event if it is a shared expense
  belongs_to :event
  # an expense always belongs to a user; the one who paid
  belongs_to :user

  before :create do
    self.spent_at = Date.today unless self.spent_at
  end

  def tagged_with?(*tag_ids)
    tag_ids = tag_ids.map { |tag| tag.id } if tag_ids.first.is_a?(Tag)
    tag_ids.any? { |tag_id| !taggings.select { |tagging| tagging.tag_id == tag_id }.empty? }
  end

  def spent_before?(date)
    !date || self.spent_at <= date
  end

  def spent_after?(date)
    puts "Is #{self.spent_at} after #{date} ?"
    !date || self.spent_at >= date
  end
end