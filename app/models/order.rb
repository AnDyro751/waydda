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

  # Embeds
  embeds_many :products
  embeds_one :address
  embeds_one :cart


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


  private

  def create_order_callback
    CreateOrderJob.perform_later(self)
  end
end
