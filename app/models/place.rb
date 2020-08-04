class Place
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include Mongoid::Slug
  include AASM

  field :name, type: String
  field :address, type: String
  field :slug, type: String
  field :status, type: String
  field :coordinates, type: Point
  slug :name
  # Relations
  belongs_to :user
  has_many :items

  aasm column: :status do
    state :pending, initial: true
    state :active
    state :inactive
    event :activate do
      transitions from: [:pending, :inactive], to: :active
      end
    event :deactivate do
      transitions from: [:pending, :active], to: :inactive
    end
  end
end
