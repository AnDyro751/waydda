class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
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

  # TODO: Crear un helper para agregar estos fields y sus actions
  field :photo, type: String, default: "places/default.png"
  field :public_stock, type: Integer, default: 0
  field :original_stock, type: Integer, default: 0
  field :sku, type: String, default: ""
  field :bar_code, type: String, default: ""

  # TODO: Agregar la cantidad publica y la privada

  # relations
  belongs_to :item, optional: true
  belongs_to :place
  has_and_belongs_to_many :cart_items
  embeds_many :aggregates

  embeds_many :images, as: :model


  validates :name, presence: true
  validates :price, presence: true


  # @param [Integer] new_value
  # @return [TrueClass, FalseClass]
  def valid_stock(new_value = nil)
    puts "---------#{new_value}------new"
    if new_value > self.public_stock
      return false
    else
      return true
    end
  end

  private

  def update_counters
    # Add Job queue
    self.place.update_products_counter(1, true)
    if self.item
      self.item.update_products_counter(1, true)
    end
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
