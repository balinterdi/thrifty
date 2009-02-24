class Participant
  include DataMapper::Resource

  property :id, Serial

  belongs_to :group
  belongs_to :event
end