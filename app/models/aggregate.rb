class Aggregate
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :name, type: String
  field :price, type: Float
  field :description, type: String
  field :default, type: Boolean

  # relations
  embedded_in :product
  # validation
  # TODO: Add validations
end
