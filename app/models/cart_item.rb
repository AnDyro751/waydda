class CartItem
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quantity, type: Integer, default: 0
  belongs_to :model, polymorphic: true
  belongs_to :cart
  # belongs_to :place
end
