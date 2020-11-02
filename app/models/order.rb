class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM # Maquina de estad
  include GlobalID::Identification

  after_create :create_order_callback

  # Fields
  field :status, type: String, default: "pending" # Estado por defecto
  field :send_to, type: Hash
  field :total_order, type: Float, default: 0.0
  field :payment_type, type: String, default: "cash"
  field :uuid, type: String
  # Relations
  belongs_to :place
  belongs_to :cart
  # Embeds
  has_many :order_items
  embeds_one :address
  # embeds_one :cart

  validates :payment_type, inclusion: {in: ["cash", "card"]}
  validates :total_order, numericality: {greater_than_or_equal_to: 1}


  # AASM STATES
  aasm column: :status do
    state :pending, initial: true
    state :received
    state :in_process
    state :cancelled
    state :completed
    state :sent

    event :to_receive do
      transitions from: [:pending], to: :received
    end

    event :to_process do
      transitions from: [:pending, :received], to: :in_process
    end

    event :to_cancel do
      transitions from: [:pending, :in_process, :sent, :received], to: :cancelled
    end
    event :to_sent do
      transitions from: [:in_process, :pending, :received], to: :sent
    end
  end


  def is_received?
    return self.received? || self.in_process? || self.sent? || self.completed?
  end


  # @note Retorna true/false si la orden está procesada o pendiente
  # @return [TrueClass, FalseClass]
  def available_for_shipping?
    return self.pending? || self.in_process?
  end

  # @note Retorna un fondo según el estado de la orden
  # @return [String]
  def get_bg
    if self.pending? || self.sent? || self.in_process? || self.received?
      return "bg-indigo-300 text-blue-900"
    else
      return "bg-red-700 text-white"
    end
  end

  # @note Retorna un true/false si el método de pago es en efectivo
  # @return [TrueClass, FalseClass]
  def is_cash?
    return self.payment_type === "cash"
  end

  # @param [Object] cart
  # @param [Object] place
  # @param [Object] address
  # @param [Object] current_user
  # @return [TrueClass]
  def self.create_new_order(cart:, place:, address:, current_user:, total:)
    new_order = place.orders.new(send_to: {name: "#{current_user.name} #{current_user.lastName}", email: current_user.email}, total_order: total, address: address, cart: cart)
    if new_order.save
      return true
    else
      raise "Ha ocurrido al crear la orden"
    end
    raise "Ha ocurrido un error al pagar con efectivo"
    return false
  end

  private

  def create_order_callback
    # TODO: Crear el job para agregar los items y luego mandar a action cable
    CreateOrderJob.perform_later(self) # Mandar el job para agregar la orden
  end
end
