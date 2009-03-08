class Expense
  include DataMapper::Resource

  property :id, Serial
  property :amount, Integer, :null => false
  property :subject, String

  has n, :taggings
  has n, :tags, :through => :taggings

  # an expense _can_ belong to an event if it is a shared expense
  belongs_to :event
  # an expense always belongs to a user; the one who paid
  belongs_to :user

  def tagged_with?(*tag_ids)
    tag_ids = tag_ids.map { |tag| tag.id } if tag_ids.first.is_a?(Tag)
    tag_ids.any? { |tag_id| !taggings.select { |tagging| tagging.tag_id == tag_id }.empty? }
  end

end