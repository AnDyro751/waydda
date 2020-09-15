class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include GlobalID::Identification
  include AASM

  require 'will_paginate/array'
  before_create :assign_slug
  after_create :update_counters

  #fields
  field :name, type: String
  field :description, type: String
  field :price, type: Float
  field :aggregates_required, type: Integer, default: 0
  field :max_aggregates, type: Integer, default: 1
  field :slug, type: String
  field :last_viewed, type: DateTime
  field :unlimited, type: Boolean, default: false
  field :status, type: String, default: "active"
  # TODO: Crear un helper para agregar estos fields y sus actions
  field :photo, type: String, default: "places/default.png"
  field :public_stock, type: Integer, default: 0
  field :original_stock, type: Integer, default: 0
  field :sku, type: String, default: ""
  field :bar_code, type: String, default: ""
  field :quantity, type: String
  field :quantity_measure, type: String
  # TODO: Agregar la cantidad publica y la privada

  # relations
  belongs_to :place
  has_and_belongs_to_many :items
  has_and_belongs_to_many :cart_items
  embeds_many :aggregate_categories

  embeds_many :images, as: :model


  validates :name, presence: true, length: {in: 4..30}
  validates :price, presence: true, numericality: {only_integer: false}
  validates :status, presence: true, inclusion: {in: %w[active inactive]}
  validates :quantity, numericality: {greater_than_or_equal_to: 1}, allow_blank: true
  validates :quantity_measure, inclusion: {in: %w[kg grm oz ml l m2 m3 v pzas]}, allow_blank: true
  validates :price, numericality: {greater_than_or_equal_to: 1}
  validate :quantity_validations

  def quantity_validations
    if quantity.present?
      unless quantity_measure.present?
        errors.add(:quantity_measure, "selecciona una unidad de medida")
      end
    end
  end

  # @param [Integer] new_value
  # @return [TrueClass, FalseClass]
  def valid_stock(new_value = nil)
    if new_value > self.public_stock
      false
    else
      true
    end
  end

  aasm column: :status do
    state :active, initial: true
    state :inactive

    event :activate do
      transitions from: [:inactive], to: :active
    end
    event :deactivate do
      transitions from: [:active], to: :inactive
    end
  end

  def get_quantity_measure
    case self.quantity_measure
    when "kg"
      ActionController::Base.helpers.pluralize(self.quantity, 'kilogramo', "kilogramos")
    when "grm"
      ActionController::Base.helpers.pluralize(self.quantity, 'gramo', "gramos")
    when "oz"
      ActionController::Base.helpers.pluralize(self.quantity, 'onza', "onzas")
    when "ml"
      ActionController::Base.helpers.pluralize(self.quantity, 'mililitro', "mililitros")
    when "m2"
      ActionController::Base.helpers.pluralize(self.quantity, 'metro cuadrado', "metros cuadrados")
    when "m3"
      ActionController::Base.helpers.pluralize(self.quantity, 'metro cúbico', "metros cúbicos")
    when "pzas"
      ActionController::Base.helpers.pluralize(self.quantity, 'pieza', "piezas")
    else
      "error"
    end
  end

  private

  def self.current_measures
    # kg grm oz ml l m2 m3
    [["Kilogramo", "kg"], ["Gramos", "grm"], ["Onzas", "oz"], ["Mililitros", "ml"], ["Litros", "l"], ["Metros Cuadrados", "m2"], ["Metros Cúbicos", "m3"], ["Unidades/ Piezas", "pzas"]]
  end

  def self.update_recent_products(item_ids:, product:, action: "create")
    item_ids = item_ids.select { |item| item.length > 0 }
    item_ids.each do |item_id|
      UpdateRecentProductsJob.perform_later(item_id: item_id, product: product, action: action)
    end
  end

  def update_counters
    # Add Job queue
    self.place.update_products_counter(1, true)
  end

  def assign_slug
    self.slug = "#{self.name.parameterize}-#{SecureRandom.hex(10)}"
  end


  # @param [String] attribute
  # @param [String] id
  # @return [Hash] {success: Boolean, error: String}
  # @param [String] new_value
  # @param [CurrentUser] current_user
  def self.update_attribute(attribute, id, new_value, current_user)
    product = Product.find(id)
    return {success: false, error: 'No se ha encontrado el recurso'} if product.nil?
    # PARENT -> Place
    # Valid place owner
    place = product.place
    return {success: false, error: 'No se ha encontrado el recurso'} unless current_user.id == place.user_id
    begin
      product.update("#{attribute}": new_value)
    rescue
      return {success: false, error: 'Ha ocurrido un error al cargar la foto'}
    end
    return {success: true, error: nil}
  end

end
