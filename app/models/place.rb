class Place
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include AASM

  # Callbacks
  before_create :assign_slug

  field :name, type: String
  field :address, type: String
  field :slug, type: String
  field :status, type: String
  field :coordinates, type: Point
  field :total_items, type: Integer, default: 0
  field :total_products, type: Integer, default: 0
  # Relations
  belongs_to :user
  has_many :items
  has_many :products

  # Validations
  validates :name, presence: true, length: {in: 4..30}
  validates :address, presence: true, length: {in: 4..60}

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


  # @param [Integer] quantity
  # @param [Boolean] plus {true: +, false: - }
  def update_products_counter(quantity, plus)
    oper = plus ? self.total_products + quantity : self.total_products - quantity
    self.update(total_products: oper)
  end

  private

  def assign_slug
    loop do
      self.slug = "#{self.name.parameterize}-#{SecureRandom.hex(4)}"
      other_place = Place.find_by(slug: self.slug)
    break if other_place.nil?
    end
  end

end
