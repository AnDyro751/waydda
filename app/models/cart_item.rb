class CartItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include GlobalID::Identification

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

  def self.get_aggregates_and_product_price(product:, aggregates:)
    if aggregates.length <= 0
      puts "NO HAY AGGREGATES"
      return product.price
    else
      new_price = product.price
      all_aggregates = AggregateCategory.get_all_aggregates(aggregate_categories: product.aggregate_categories)
      current_aggregates = []
      puts "-------#{aggregates}"
      aggregates.each do |agg|
        puts "----------#{agg}"
        agg["subvariants"].each { |sb| current_aggregates << sb["_id"].to_s }
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
    this_product = self.product
    if quantity > this_product.public_stock
      unless this_product.unlimited
        raise "Ha ocurrido un error al actualizar la cantidad"
        return false
      end
    end
    if quantity <= 0
      new_quantity = self.cart.quantity - self.quantity
      if new_quantity <= 0
        new_quantity = 0
      end
      self.cart.update(quantity: new_quantity)
      return self.destroy
    end
    new_quantity = if force
                     quantity
                   else
                     add ? self.quantity + quantity : self.quantity - quantity
                   end
    new_quantity = 0 if new_quantity <= 0
    logger.warn "-----------NUEVA CANTIDAD #{new_quantity}"
    return self.update(quantity: new_quantity)
  end

end
