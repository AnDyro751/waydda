class CartItem
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quantity, type: Integer, default: 0
  field :added_in, type: Boolean, default: false
  belongs_to :model, polymorphic: true
  embedded_in :cart
end
