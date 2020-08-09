class CartItem
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :model, polymorphic: true
  belongs_to :cart
  # belongs_to :place
end
