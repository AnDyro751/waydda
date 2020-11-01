class Cart

  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM
  include GlobalID::Identification

  before_create :assign_uuid

  field :quantity, type: Integer, default: 0
  field :payment_type, type: String, default: "cash"
  field :status, type: String, default: "pending"
  field :delivery_kind, type: String, default: "pickup"
  field :uuid, type: String

  has_many :cart_items
  has_one :order
  embeds_one :delivery_option
  embeds_one :checkout
  embeds_many :addresses, as: :model
  belongs_to :place
  belongs_to :user, optional: true

  validates :payment_type, inclusion: {in: %w[card cash]}
  validates :status, presence: true, inclusion: {in: %w[pending success]}
  validates :delivery_kind, presence: true, inclusion: {in: %w[pickup delivery]}


  aasm column: :status do
    state :pending, initial: true
    state :success
    event :to_success do
      transitions from: [:pending], to: :success
    end
  end

  def get_valid_delivery
    if self.place.kind === "premium"
      return %w(delivery pickup)
    else
      return ["pickup"]
    end
  end

  def get_valid_payment_type(this_place)
    if self.payment_type === "card"
      if this_place.valid_payment_methods.length == 2
        return "card"
      else
        return "cash"
      end
    else
      return "cash"
    end
  end

  def self.get_total(old_items = nil)
    total = 0
    old_items.each do |i|
      unless i.product.nil?
        new_product_price = i.get_aggregates_and_product_price(product: i.product)
        puts "------------_#{new_product_price}"
        total = total + (new_product_price * i.quantity)
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
    logger.warn "CART #{aggregates}"
    if valid_sale?(product: product, place: place, aggregates: aggregates, quantity: quantity)
      return self.create_or_update_cart_item(product: product, aggregates: aggregates, quantity: quantity)
    end
    logger.warn "Cart have invalid sale"
    return false
  end

  # @note Crea o actualiza la instancia del carrito
  # @param [Object] product
  # @return [TrueClass, FalseClass]
  def create_or_update_cart_item(product:, aggregates:, quantity: 1)
    begin
      current_cart_item = self.cart_items.find_by(product: product, aggregates: aggregates)
      if current_cart_item.nil?
        logger.warn "CURRENT CART ITEM ES NULO"
        self.create_cart_item(product: product, aggregates: aggregates, quantity: quantity)
      else
        if (current_cart_item.quantity + quantity) > product.get_public_stock
          raise "No puedes agregar más productos al carrito"
          return false
        else
          return current_cart_item.update_quantity(quantity: quantity)
        end
      end
    rescue => e
      logger.warn "Error al crear o actualizar item #{e}"
      raise "#{e}"
      return false
    end
  end

  # @note Crea el cart item de la instancia del carrito
  # @param [Object] product
  # @return [TrueClass]
  def create_cart_item(product:, aggregates:, quantity: 1)
    new_cart_item = self.cart_items.new(product: product, aggregates: aggregates, quantity: quantity)
    return false if quantity > 51
    raise "No puedes agregar tantos productos al carrito" if quantity > 51
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

  # @note muestra el total de productos
  # si la cantidad es mayor a 9 entonces hace truncade de la cantidad y muestra +9
  # De lo contrario muestra la cantidad adecuada
  # @return [String]
  def get_public_quantity
    if self.quantity <= 0
      return "0"
    else
      if self.quantity > 9
        return "+9"
      else
        return self.quantity
      end
    end
  end


  # @param [Object] params
  # @return [Array] new_params
  def self.seralize_params(params:)
    new_params = []
    begin
      if params["radio_ids"]
        params["radio_ids"].each do |k, v|
          new_params << {id: k, subvariants: [v]} if v.kind_of?(String)
        end
      end
      if params["checkbox_ids"]
        params["checkbox_ids"].each do |k, v|
          new_params << {id: k, subvariants: v} if v.kind_of?(Array)
        end
      end
    rescue => e
      logger.warn "ERROR #{e} LN 175"
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

  def create_new_cash_order(place:, address:, current_user:, total:)
    begin
      if Order.create_new_order(uuid: self.uuid, payment_type: "cash", cart: self, place: place, address: address, current_user: current_user, total: total)
        return self.update(status: "success")
      else
        raise "Ha ocurrido un error al crear la orden"
      end
    rescue => e
      raise "#{e.message}" if e.message
      raise "Ha ocurrido un error al crear la orden" unless e.message
    end
    return false
  end

  def create_new_card_order(place:, address:, current_user:, total:, token_id:)

    begin
      logger.warn "TOKEN ID NO ESTÁ PRESENTE" unless token_id.present?
      raise "Ha ocurrido un error al procesar el cargo - el token es nulo - #{token_id}" unless token_id.present?
      return false unless token_id.present?
      Stripe::Charge.create({
                                amount: (total * 100).to_i,
                                currency: 'mxn',
                                source: token_id,
                                description: "Compra en #{place.name} - Waydda México",
                                on_behalf_of: place.account.account_id
                            })
      if Order.create_new_order(uuid: self.uuid, payment_type: "card", cart: self, place: place, address: address, current_user: current_user, total: total)
        return self.update(status: "success")
      else
        logger.warn "ERROR EN CREATE NEW_ORDER"
        raise "Ha ocurrido un error al procesar el cargo - no se ha creado la orden"
      end
    rescue => e
      logger.warn "-------#{e}"
      raise "Ha ocurrido un error al procesar el pago - Stripe error"
      # format.json { render json: {errors: "Ha ocurrido un error al crear el cargo"}, status: :unprocessable_entity }
    end
  end


  private

  # @note Callback - before_create
  # Asigna el uuid para después mostrarlo en el carrito
  def assign_uuid
    self.uuid = SecureRandom.rand.to_s.split(".")[1].slice(0, 8)
  end

end
