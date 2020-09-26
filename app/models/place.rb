class Place
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include AASM
  include AlgoliaSearch
  include GlobalID::Identification
  require 'will_paginate/array'
# Rolify
  resourcify

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
  field :external_number, type: String
  field :slug, type: String
  field :city, type: String
  field :city_state, type: String
  field :status, type: String, default: "active"
  field :lat, type: Float
  field :lng, type: Float
  field :location, type: Point
  field :photo, type: String, default: "places/default.png"
  field :cover, type: String, default: "waydda.png"
  field :total_items, type: Integer, default: 0
  field :total_products, type: Integer, default: 0
  field :kind, type: String, default: "free"
  field :trial_will_end, type: Boolean, default: false
  field :in_free_trial, type: Boolean, default: true
  field :trial_used, type: Boolean, default: false
  field :category, type: String
  field :other_category, type: String
  field :pickup_time, type: String, default: "0"
# DELIVERY
  field :delivery_option, type: Boolean, default: false
  field :delivery_cost, type: Float, default: 20
  field :delivery_distance, type: Float, default: 5
  field :delivery_extra_cost, type: Float, default: 0

# TODO: Añadir horarios de envío y recolección
# TODO: Añadir pedido minimo
# Relations
  belongs_to :user
  has_many :items
  has_many :products
  has_many :viewers
  has_many :views
  has_many :orders # Todas las ordenes que recibe
  embeds_one :subscription
  has_one :account

# Validations
  validates :name, presence: true, length: {in: 4..40}
  validates :address, presence: true, length: {in: 4..100}
  validates :status, presence: true, inclusion: {in: %w(pending active inactive)}
  validates :pickup_time, inclusion: {in: %w(0 1 2 3)}
  validates :category, inclusion: {in: %w(groceries food services other)}, allow_blank: true
  validates :other_category, length: {in: 0..40}, allow_blank: true
  validates :kind, presence: true, inclusion: {in: %w(free premium)}
  validates :slug, uniqueness: true
  validates :delivery_cost, numericality: {greater_than_or_equal_to: 0}
  validates :delivery_distance, numericality: {greater_than_or_equal_to: 0.3}
# validates :city, presence: true


  aasm column: :status do
    state :pending
    state :active, initial: true
    state :inactive

    event :activate do
      transitions from: [:pending, :inactive], to: :active
    end
    event :deactivate do
      transitions from: [:pending, :active], to: :inactive
    end
  end

  aasm column: :kind do
    state :free, initial: true
    state :premium

    event :to_premium do
      transitions from: [:free], to: :premium
    end
    event :to_free do
      transitions from: [:premium, :free], to: :free
    end
  end


# @param [Integer] quantity
# @param [Boolean] plus {true: +, false: - }
  def update_products_counter(quantity, plus)
    oper = plus ? self.total_products + quantity : self.total_products - quantity
    self.update(total_products: oper)
  end


  def valid_sale?
    unless self.nil?
      logger.warn "Place is not active" unless self.status === "active"
      raise "Esta empresa no está disponible" unless self.status === "active"
      return self.status === "active"
    end
    raise "Esta empresa no está disponible"
    false
  end

  def self.get_pickup_times
    [["10 - 15 minutos", "0"], ["15 - 30 minutos", "1"], ["30 - 45 minutos", "2"], ["Más de una hora", "3"]]
  end

  def get_pickup_time
    Place.get_pickup_times.find { |a| a[1] === self.pickup_time }[0]
  end


  private


  def self.current_categories
    [%w[Abarrotes groceries], %w[Alimentos food], %w[Servicios services], %w[Otros other]]
  end

  def self.cancel_subscription(subscription_id)
    get_subscription = Subscription.find_by(stripe_subscription_id: subscription_id)
    return nil if get_subscription.nil?
    current_place = get_subscription.place
    return nil if current_place.nil?
    puts "----------#{current_place.nil?} PLACE NIL #{subscription_id}"
    # current_subscription = Subscription.cancel_subscription(subscription_id)
    # puts "----------#{current_subscription} CANCEL SUBS"
    # return nil if current_subscription === false
    current_place.update(kind: "free", in_free_trial: false, trial_will_end: false)
    current_place.subscription.destroy
  end

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
    self.user.update(is_admin: true)
  end

# @param [Object] user
# @return [Object] Account link
  def self.create_stripe_account_link(user)
    Account.create_stripe_account(self, user)
  end
end

