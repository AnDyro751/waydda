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
    # return add_item(self, current_item, product, quantity, user_logged_in) if plus
    # return remove_item(self, current_item, product, quantity, user_logged_in) unless plus
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
  #

  def add_item(product:, place:, quantity:, aggregates: [])
    if valid_sale?(product: product, place: place, aggregates: aggregates, quantity: quantity)
      self.create_or_update_cart_item(product: product)
      return true
    end
    logger.warn "Cart have invalid sale"
    false
  end

  # @note Crea o actualiza la instancia del carrito
  # @param [Object] product
  # @return [TrueClass, FalseClass]
  def create_or_update_cart_item(product:)
    begin
      current_cart_item = self.cart_items.find_by(product: product)
      if current_cart_item.nil?
        logger.warn "CURRENT CART ITEM ES NULO"
        self.create_cart_item(product: product)
      else
        return current_cart_item.update_quantity(quantity: 1)
      end
    rescue => e
      logger.warn "Error al crear o actualizar item #{e}"
      return false
    end
  end

  # @note Crea el cart item de la instancia del carrito
  # @param [Object] product
  # @return [TrueClass]
  def create_cart_item(product:)
    new_cart_item = self.cart_items.new(product: product)
    if new_cart_item.save
      new_cart_quantity = self.quantity + 1
      return self.update(quantity: new_cart_quantity)
    else
      logger.warn "Error creando el line item"
      raise "Ha ocurrido un error"
      return false
    end
  end

  # @param [Object] product
  # @param [Object] place
  # @param [Array] aggregates
  # @param [Object] quantity
  # @return [TrueClass, FalseClass]
  # params["checkbox_ids"].each {|k, v| new_params << {id: k, subvariants: v}} DEMO
  def valid_sale?(product:, place:, aggregates: [], quantity:)
    # raise ActionController::RoutingError.new('Not Found')
    place.valid_sale? and product.valid_sale?(quantity: quantity) and product.valid_aggregates_sale?(aggregates: aggregates)
  end

  # def add_item(current_cart, current_item, product, quantity = 1, user_logged_in)
  #   new_quantity = current_item.quantity + quantity unless current_item.nil?
  #   new_quantity = quantity if current_item.nil?
  #   new_cart_quantity = current_cart.quantity + quantity
  #   return {success: false, total_items_counter: nil, total_items_cart: nil} unless product.valid_stock(new_quantity)
  #   if current_item.nil?
  #     begin
  #       current_cart.cart_items.create!(product: product, quantity: new_quantity, added_in: user_logged_in)
  #       current_cart.update(quantity: new_cart_quantity)
  #       return {success: true, total_items_counter: new_quantity, total_items_cart: current_cart.quantity}
  #     rescue
  #       return {success: false, total_items_counter: nil, total_items_cart: nil}
  #     end
  #   else
  #     if current_item.update(quantity: new_quantity)
  #       current_cart.update(quantity: new_cart_quantity)
  #       return {success: true, total_items_counter: current_item.quantity, total_items_cart: current_cart.quantity}
  #     else
  #       return {success: false, total_items_counter: nil, total_items_cart: nil}
  #     end
  #   end
  # end
  #
  #

  # @param [Object] params
  # @return [Array] new_params
  def self.seralize_params(params:)
    new_params = []
    begin
      params["radio_ids"].each do |k, v|
        new_params << {id: k, subvariants: [v]} if v.kind_of?(String)
      end
      params["checkbox_ids"].each do |k, v|
        new_params << {id: k, subvariants: v} if v.kind_of?(Array)
      end
    rescue
      return []
    end
    return new_params
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
