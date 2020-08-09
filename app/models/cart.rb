class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quantity, type: Integer, default: 0
  has_many :cart_items
  belongs_to :user, optional: true

  def get_total
    total = 0
    items = self.cart_items.includes(:model)
    items.each do |i|
      total = total + (i.model.price * i.quantity)
    end
    total
  end

  # @param [String] product_id
  # @return [Array] [response, total_products]
  def add_item(product_id)
    product = Product.find_by(id: product_id)
    return [false, nil] if product.nil?
    return [false, nil] if product.public_stock <= 0
    current_item = self.cart_items.find_by(model_id: product_id)
    new_cart_quantity = self.quantity + 1
    if current_item.nil?
      begin
        self.cart_items.create!(model: product, quantity: 1)
        self.update(quantity: new_cart_quantity)
        return [true, 1]
      rescue
        return [false, nil]
      end
    else
      return [false, nil] if current_item.quantity > product.public_stock
      new_quantity = current_item.quantity + 1
      # puts "#{new_quantity}----------"
      if current_item.update(quantity: new_quantity)
        self.update(quantity: new_cart_quantity)
        return [true, new_quantity]
      else
        return [false, nil]
      end
    end
  end

end
