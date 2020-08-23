class Place
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include AASM
  include AlgoliaSearch
  # Algolia search
  algoliasearch do
    attributes :name, :address, :slug, :lat, :lng #, :city, :city_state
    geoloc :lat, :lng
  end

  # Callbacks
  before_create :assign_slug
  after_create :add_owner_role


  field :name, type: String
  field :address, type: String
  field :slug, type: String
  # field :city, type: String
  # field :city_state, type: String
  field :status, type: String
  field :lat, type: Float
  field :lng, type: Float
  field :location, type: Point
  field :photo, type: String, default: "places/default.png"
  field :cover, type: String, default: "waydda.png"
  field :total_items, type: Integer, default: 0
  field :total_products, type: Integer, default: 0
  field :delivery_option, type: Boolean, default: false
  field :delivery_cost, type: Boolean, default: 10
  # Relations
  belongs_to :user
  has_many :items
  has_many :products
  has_many :viewers
  has_many :views

  # Validations
  validates :name, presence: true, length: {in: 4..30}
  validates :address, presence: true, length: {in: 4..100}

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

  def self.update_attribute(attribute, id, new_value, current_user)
    place = Place.find_by(id: id)
    return {success: false, error: 'No se ha encontrado el recurso'} if place.nil? || place.pending?
    # PARENT -> User
    # Valid place owner
    return {success: false, error: 'No se ha encontrado el recurso'} unless current_user.id == place.user_id
    begin
      place.update("#{attribute}": new_value)
    rescue
      return {success: false, error: 'No se ha encontrado el recurso'}
    end
    return {success: true, error: nil}
  end

  def assign_slug
    loop do
      self.slug = "#{self.name.parameterize}-#{SecureRandom.hex(4)}"
      other_place = Place.find_by(slug: self.slug)
      break if other_place.nil?
    end
  end

  def add_owner_role
    self.user.add_role(:owner, self)
  end
end

