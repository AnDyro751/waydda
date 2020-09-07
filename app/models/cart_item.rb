class CartItem
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quantity, type: Integer, default: 0
  field :added_in, type: Boolean, default: false
  has_and_belongs_to_many :products
  belongs_to :cart
end
