class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM # Maquina de estad
  include GlobalID::Identification

  after_create :create_order_callback

  # Fields
  field :status, type: String, default: "pending" # Estado por defecto
  field :send_to, type: Hash
  # Relations
  belongs_to :place
  belongs_to :cart
  # Embeds
  embeds_many :products
  embeds_one :address
  # embeds_one :cart


  # AASM STATES
  aasm column: :status do
    state :pending, initial: true
    state :in_process
    state :cancelled
    state :sent

    event :to_process do
      transitions from: [:pending], to: :in_process
    end

    event :cancel do
      transitions from: [:pending], to: :cancelled
    end
    event :to_sent do
      transitions from: [:in_process, :pending], to: :sent
    end
  end


  # @param [Object] cart
  # @param [Object] place
  # @param [Object] address
  # @param [Object] current_user
  # @return [TrueClass]
  def self.create_cash_order(cart:, place:, address:, current_user:)
    if cart.payment_type === "cash"
      new_order = place.orders.new(send_to: {name: "#{current_user.name} #{current_user.lastName}", email: current_user.email}, address: address, cart: cart)
      if new_order.save
        return true
      else
        raise "Ha ocurrido al crear la orden"
      end
    end
    raise "Ha ocurrido un error al pagar con efectivo"
    return false
  end

  private

  def create_order_callback
    # TODO: Crear el job para agregar los items y luego mandar a action cable
    # CreateOrderJob.perform_later(@current_address.attributes, current_user.attributes, @current_cart.attributes) # Mandar el job para agregar la orden
  end
end
