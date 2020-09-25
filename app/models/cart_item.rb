class CartItem
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quantity, type: Integer, default: 1
  field :added_in, type: Boolean, default: false
  field :aggregates, type: Array, default: []

  belongs_to :product
  belongs_to :cart

  validates_associated :cart
  validates :product, presence: true

  def update_quantity(quantity:)
    new_quantity = self.quantity + 1
    new_cart_quantity = self.cart.quantity + 1
    self.cart.update(quantity: new_cart_quantity)
    return self.update(quantity: new_quantity)
  end

end
