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

  def get_aggregates_and_product_price(product:)
    if self.aggregates.length <= 0
      return product.price
    else
      new_price = product.price
      all_aggregates = AggregateCategory.get_all_aggregates(aggregate_categories: product.aggregate_categories)
      current_aggregates = []
      self.aggregates.each do |agg|
        agg["subvariants"].each { |sb| current_aggregates << sb }
      end
      all_aggregates.each do |agg|
        if current_aggregates.include? agg.id.to_s
          new_price = new_price + agg.price
        end
      end
    end
    return new_price
  end

  def update_quantity(quantity:, force: false, add: true)
    if quantity > self.product.public_stock
      raise "Ha ocurrido un error al actualizar la cantidad"
      return false
    end
    if quantity <= 0
      return self.destroy
    end
    new_quantity = if force
                     quantity
                   else
                     add ? self.quantity + 1 : self.quantity - 1
                   end
    new_cart_quantity = self.cart.quantity + 1
    logger.warn "-----------NUEVA CANTIDAD #{new_quantity}"
    self.cart.update(quantity: new_cart_quantity)
    return self.update(quantity: new_quantity)
  end

end
