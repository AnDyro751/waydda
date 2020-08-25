class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quantity, type: Integer, default: 0
  field :intent_id, type: String, default: nil
  field :client_secret, type: String, default: nil
  has_many :cart_items
  embeds_one :delivery_option
  embeds_many :addresses, as: :model
  embeds_one :checkout
  belongs_to :place
  belongs_to :user, optional: true

  def self.get_total(old_items = nil)
    total = 0
    old_items.each do |i|
      unless i.product.nil?
        total = total + (i.product.price * i.quantity)
      end
    end
    total
  end


  def update_item(product_id, quantity, plus, user_logged_in = false)
    # TODO: Update intent
    product = Product.find_by(id: product_id)
    return [false, nil] if product.nil?
    current_item = self.cart_items.find_by(product_id: product_id)
    return add_item(self, current_item, product, quantity, user_logged_in) if plus
    return remove_item(self, current_item, product, quantity, user_logged_in) unless plus
  end

  def add_item(current_cart, current_item, product, quantity = 1, user_logged_in)
    new_quantity = current_item.quantity + quantity unless current_item.nil?
    new_quantity = quantity if current_item.nil?
    new_cart_quantity = current_cart.quantity + quantity
    return {success: false, total_items_counter: nil, total_items_cart: nil} unless product.valid_stock(new_quantity)
    if current_item.nil?
      begin
        current_cart.cart_items.create!(product: product, quantity: new_quantity, added_in: user_logged_in)
        current_cart.update(quantity: new_cart_quantity)
        return {success: true, total_items_counter: new_quantity, total_items_cart: current_cart.quantity}
      rescue
        return {success: false, total_items_counter: nil, total_items_cart: nil}
      end
    else
      if current_item.update(quantity: new_quantity)
        current_cart.update(quantity: new_cart_quantity)
        return {success: true, total_items_counter: current_item.quantity, total_items_cart: current_cart.quantity}
      else
        return {success: false, total_items_counter: nil, total_items_cart: nil}
      end
    end
  end

  def remove_item(current_cart, current_item, product, quantity, user_logged_in)
    return {success: false, total_items_counter: nil, total_items_cart: nil} if current_item.nil?
    new_quantity = current_item.quantity - quantity
    if new_quantity <= 0
      # Se elimina el item
      # Eliminar el intent
      # Update intent
      begin
        current_item.destroy
        current_cart.update(quantity: current_cart.quantity - quantity)
        return {success: true, total_items_counter: nil, total_items_cart: current_cart.quantity}
      rescue
        return {success: false, total_items_counter: nil, total_items_cart: nil}
      end
    else
      begin
        # Update intent
        current_item.update(quantity: new_quantity)
        current_cart.update(quantity: current_cart.quantity - quantity)

        return {success: true, total_items_counter: current_item.quantity, total_items_cart: current_cart.quantity}
      rescue
        return {success: true, total_items_counter: nil, total_items_cart: nil}
      end

    end
  end


end
