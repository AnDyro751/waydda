class OrderItem

  include Mongoid::Document
  include Mongoid::Timestamps

  field :aggregates, type: Array, default: []
  field :quantity, type: Integer, default: 0

  embeds_one :product
  belongs_to :order

end
