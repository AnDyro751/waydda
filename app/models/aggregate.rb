class Aggregate
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :name, type: String
  field :price, type: Float
  field :description, type: String
  field :default, type: Boolean
  field :add_to_price_product, type: Boolean, default: true
  # TODO: Agregar helper
  field :public_stock, type: Integer, default: 0
  field :original_stock, type: Integer, default: 0
  field :sku, type: String, default: ""
  field :bar_code, type: String, default: ""
  # relations
  embedded_in :product
  # validation
  # TODO: Add validations
  validates :name, presence: true, length: {in: 2..40}
  validates :price, presence: true
end
