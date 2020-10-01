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
  field :unlimited, type: Boolean, default: true
  field :status, type: String, default: "active"
  # TODO: Crear un helper para agregar estos fields y sus actions
  field :photo, type: String, default: "places/default.png"
  field :public_stock, type: Integer, default: 0
  field :original_stock, type: Integer, default: 0
  field :sku, type: String, default: ""
  field :bar_code, type: String, default: ""
  field :quantity, type: String
  field :quantity_measure, type: String, default: "pzas"
  # TODO: Agregar la cantidad publica y la privada

  # relations
  belongs_to :place
  has_and_belongs_to_many :items

  has_many :cart_items
  embeds_many :aggregate_categories
  accepts_nested_attributes_for :aggregate_categories

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


  def get_simple_quantity_measure
    case self.quantity_measure
    when "kg"
      "Kilogramos"
    when "grm"
      "Gramos"
    when "oz"
      "Onzas"
    when "ml"
      "Mililitros"
    when "m2"
      "Metros cuadrados"
    when "m3"
      "Metros cubicos"
    when "pzas"
      "Piezas"
    else
      "error"
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

  # @return [TrueClass]
  def valid_sale?(quantity:)
    logger.warn "La cantidad no puede ser menor o igual a 0" if quantity <= 0
    raise "Este producto no está disponible" if quantity <= 0
    return false if quantity <= 0
    unless self.nil?
      logger.warn "Status-#{self.status} - #{self.active?}"
      if self.active?
        if (self.public_stock - quantity) >= 0
          return true
        else
          logger.warn "Product is not unlimited #{self.public_stock - quantity}" unless self.unlimited
          raise "Este producto no está disponible" unless self.unlimited
          return self.unlimited
        end
      end
      raise "Este producto no está disponible"
      logger.warn "Product is not active"
      return false
    end
    raise "Este producto no está disponible"
    logger.warn "Product is nil"
    false
  end


  # @param [Array] aggregates
  # @return [TrueClass, FalseClass]
  # @param aggregate example
  #
  # aggregates: [{id: "12345", subvariants:["12", "123"]}]
  # Donde el id de cada elemento es un AggregateCategory y la subvariante es un array de
  # los aggregates que el padre contiene.
  # Es decir que los ids, 12 y 123 debes estar dentro de los ids que tiene el AggregateCategory padre
  # De lo contrario mandamos un error
  #
  def valid_aggregates_sale?(aggregates: [])

    logger.warn "-Aggregates #{aggregates} "
    current_aggregate_categories = self.aggregate_categories
    logger.warn "#LN 135 - #{current_aggregate_categories}"

    # current_aggregates_required = AggregateCategory.get_required(items: current_aggregate_categories)
    # logger.warn "#LN 135 - #{current_aggregates_required}"

    valid_aggregates_categories = AggregateCategory.get_all_valid(items: aggregates, all: current_aggregate_categories)
    logger.warn "#LN 138 - #{valid_aggregates_categories}"

    # required_aggregate_category_ids = AggregateCategory.get_ids(items: current_aggregate_categories)
    valid_elements = Aggregate.valid_elements(items: aggregates, aggregates: current_aggregate_categories)
    logger.warn "Valid elements ---- #{valid_elements}"
    aggregate_categories_ids = AggregateCategory.get_ids(items: valid_elements)
    logger.warn "Aggregate categories ids ---- #{aggregate_categories_ids}"
    receive_aggregates_ids = Aggregate.get_valid_ids_in_aggregates(ids: aggregate_categories_ids, aggregates: AggregateCategory.get_ids(items: current_aggregate_categories))
    logger.warn "#LN 143 - #{receive_aggregates_ids}"
    # valid_aggregates_ids = AggregateCategory.get_all_valid(items: receive_aggregates_ids, all: required_aggregate_category_ids)

    if (valid_aggregates_categories - receive_aggregates_ids).length == 0
      logger.warn "No hay ninguún aggregate category fake"
      current_aggregates = AggregateCategory.get_all_aggregates(aggregate_categories: current_aggregate_categories)
      logger.warn "Aggregate ids #{receive_aggregates_ids}-------#{current_aggregates}"
      return true
    end
    logger.warn "Los aggregates son invalidos #{valid_aggregates_categories}-#{receive_aggregates_ids}."
    raise "Selecciona los elementos que son obligatorios"
    false

    # (aggregate_ids - aggregates) == 0
    # TODO: Validate aggregates
    # Buscamos los aggregados que tengan como true el field required
    # Creamos un array con los ids de los requeridos
    # el @param aggregates nos debe mandar un array con los ids seleccionados en la vist
    # Restamos todos los ids que nos mandaron con los ids que deben estar aggregados
    # Si hay algún id restante debemos retornar false
    # De lo contrario retornamos el true
    # Si manda un id incorrecto de todos modos van a existir ids que no se restaron
    #
  end


  def get_truncate(quantity = 1)
    if quantity >= 51
      return 20
    else
      return quantity
    end
  end

  private

  def self.current_measures
    # kg grm oz ml l m2 m3
    [["Kilogramos", "kg"], ["Gramos", "grm"], ["Onzas", "oz"], ["Mililitros", "ml"], ["Litros", "l"], ["Metros Cuadrados", "m2"], ["Metros Cúbicos", "m3"], ["Unidades / Piezas", "pzas"]]
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
