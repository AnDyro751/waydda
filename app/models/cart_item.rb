class CartItem
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quantity, type: Integer, default: 1
  field :added_in, type: Boolean, default: false
  has_and_belongs_to_many :products
  belongs_to :cart

  validates_associated :cart
  validates :products, presence: true

  def update_quantity(quantity:)
    new_quantity = self.quantity + 1
    new_cart_quantity = self.cart.quantity + 1
    self.cart.update(quantity: new_cart_quantity)
    return self.update(quantity: new_quantity)
  end

end
