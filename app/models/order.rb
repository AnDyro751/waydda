class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM # Maquina de estad
  include GlobalID::Identification

  after_create :create_order_callback
  before_create :assign_qrcode

  # Fields
  field :status, type: String, default: "pending" # Estado por defecto
  field :send_to, type: Hash
  field :total_order, type: Float, default: 0.0
  field :payment_type, type: String, default: "cash"
  field :shipment_type, type: String, default: "pickup"
  field :cancel_reason, type: String
  field :uuid, type: String
  # Relations
  belongs_to :place
  belongs_to :cart
  belongs_to :user
  # Embeds
  has_many :order_items
  embeds_one :address
  # embeds_one :cart

  validates :payment_type, inclusion: {in: %w[cash card]}
  validates :total_order, numericality: {greater_than_or_equal_to: 1}
  validates :cancel_reason, length: {in: 0..400}, allow_blank: true

  # AASM STATES
  aasm column: :status do
    state :pending, initial: true
    state :received
    state :in_process
    state :cancelled
    state :completed
    state :sent

    event :to_receive do
      after do
        OrderMailer.customer_order_received(order: self).deliver_later
        # Mandar un email para decirle al usuario que el negocio ha recibido la orden
      end
      transitions from: [:pending], to: :received
    end

    event :to_process do
      after do
        OrderMailer.customer_order_process(order: self).deliver_later
        # Mandar un email para decirle al usuario que el negocio está procesando el pedido
      end
      transitions from: [:pending, :received], to: :in_process
    end

    event :to_cancel do
      after do
        OrderMailer.customer_order_cancelled(order: self).deliver_later
        # Mandar un email para decirle al usuario que el negocio ha cancelado la orden
      end
      transitions from: [:pending, :in_process, :sent, :received], to: :cancelled
    end
    event :to_sent do
      after do
        # Mandar un email para ver si el pedido se realizó par pickup o envío
        # Mandar un email para decirle al usuario que el negocio ha enviado la orden
      end
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
    if self.pending? || self.in_process? || self.received?
      return "bg-indigo-300 text-blue-900"
    elsif self.sent?
      return "bg-green-300 text-green-900"
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
    new_order = place.orders.new(user: current_user, uuid: cart.uuid, payment_type: "cash", shipment_type: cart.delivery_kind, send_to: {name: "#{current_user.name} #{current_user.lastName}", phone: current_user.phone, email: current_user.email}, total_order: total, address: address, cart: cart)
    if new_order.save
      return true
    else
      raise "Ha ocurrido al crear la orden"
    end
    raise "Ha ocurrido un error al pagar con efectivo"
    return false
  end


  def self.get_image_url(height = 50, width = 50, path = nil, fit = "outside")
    waydda_base_url = "https://d1nrrr6y3ujrjz.cloudfront.net"
    image_request = {
        'bucket': 'waydda-qr',
        'key': path ? path : "places/default.png",
        'edits': {
            'resize': {
                'width': width,
                'height': height,
                'fit': fit,
                "background": {
                    "r": 255,
                    "g": 255,
                    "b": 255,
                    "alpha": 1
                }
            }
        }
    }
    begin
      image_base_64_request = Base64.strict_encode64(image_request.to_json)
      "#{waydda_base_url}/#{image_base_64_request}"
    rescue => e
      puts "----#{e}-#{image_request}"
      "/404.png"
    end
  end


  def create_qrcode
    qrcode = RQRCode::QRCode.new("https://waydda.com/dashboard/orders/#{self.id.to_s}")

    png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: 'black',
        file: "#{File.join Rails.root}/tmp/#{self.id.to_s}.png",
        fill: 'white',
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 500
    )
    return "#{File.join Rails.root}/tmp/#{self.id.to_s}.png"
  end

  private

  def assign_qrcode
    Aws.config.update({credentials: Aws::Credentials.new('AKIAYAOMZIQZPJCWNBJJ', 'zpssqm5AuysJoLswNmBwM3FXNjbArioB74it8Zjr')})
    s3 = Aws::S3::Resource.new(region: 'us-east-1')
    qrcode = self.create_qrcode
    filename = "qrcode.png"
    bucket_filename = "orders/#{self.id.to_s}/#{filename}"
    obj = s3.bucket("waydda-qr").object(bucket_filename)
    obj.upload_file(File.open qrcode)
    File.delete(qrcode)
  end

  def create_order_callback
    # TODO: Crear el job para agregar los items y luego mandar a action cable
    CreateOrderJob.perform_later(self) # Mandar el job para agregar la orden
  end
end
