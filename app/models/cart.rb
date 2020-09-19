class Cart

  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM
  include GlobalID::Identification

  field :quantity, type: Integer, default: 0
  field :payment_type, type: String, default: "cash"
  field :status, type: String, default: "pending"

  has_many :cart_items
  embeds_one :delivery_option
  embeds_one :checkout
  embeds_many :addresses, as: :model
  belongs_to :place
  belongs_to :user, optional: true

  validates :payment_type, inclusion: {in: %w[card cash]}
  validates :status, presence: true, inclusion: {in: %w[pending success]}


  aasm column: :status do
    state :pending, initial: true
    state :success
    event :to_success do
      transitions from: [:pending], to: :success
    end
  end

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

  #
  # add_item function
  #
  # @note
  # Agrega un producto al carrito
  # Verifica que el carrito exista
  # Verifica que el place exista
  # Varifica que el place se encuentre activo
  # Verifica que el producto exista
  # Verifica que el producto esté activo
  # Verifica que el producto cuente con stock necesario
  # -> Si no cuenta con stock
  # -> -> Verificar si se puede vender incluso sin stock
  # -> Si cuenta con stock
  # Verificar que todas las variantes requeridas se hayan rellenado
  # Verificar los valores correctos de las variantes
  #
  #
  # @param [Object] current_cart
  # @param [Object] current_item
  # @param [Object] product
  # @param [Integer] quantity
  # @param [Object] user_logged_in
  # @return [Hash{Symbol->FalseClass}, Hash{Symbol->TrueClass or Integer}]

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
