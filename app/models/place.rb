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
  field :total_items, type: Integer, default: 0
  field :total_products, type: Integer, default: 0
  slug :name
  # Relations
  belongs_to :user
  has_many :items
  has_many :products

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

end
