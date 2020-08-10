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
  field :photo, type: String, default: "places/default.png"
  field :public_stock, type: Integer, default: 0
  field :original_stock, type: Integer, default: 0
  # TODO: Agregar la cantidad publica y la privada

  # relations
  belongs_to :item
  belongs_to :place
  belongs_to :cart_item, optional: true #, as: :model
  embeds_many :aggregates


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
    self.item.update_products_counter(1, true)
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
      return {success: false, error: 'No se ha encontrado el recurso'}
    end
    return {success: true, error: nil}
  end

end
