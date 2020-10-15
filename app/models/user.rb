class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # include ActiveModel::SecurePassword
  include AASM
  include GlobalID::Identification

  devise :database_authenticatable, :registerable, :rememberable
  # Callbacks
  after_create :assign_default_role, if: Proc.new { self.phone.present? }
  # after_save :create_stripe_customer
  # TODO: Al registrarse y si ya cuenta con un carrito se debe hacer merge
  # after_create :merge_cart

  # Fields
  field :name, type: String
  field :lastName, type: String
  field :email, type: String
  field :requiredActions, type: Array
  field :encrypted_password, type: String
  field :status, type: String
  field :photo, type: String, default: "waydda.png"
  field :timezone, type: String
  field :remember_created_at, type: DateTime
  field :default_source, type: Hash, default: {} # Default stripe source for payments
  field :is_admin, type: Boolean, default: false
  field :price_selected, type: String # El precio que seleccionó al registrarse
  field :free_days_selected, type: String # El precio que seleccionó al registrarse
  field :stripe_customer_id, type: String, default: ""

  field :phone, type: String

  # OMNIAUTH
  field :provider, type: String
  field :uid, type: String
  field :password_changed, type: Boolean, default: false

  # Relations
  has_many :places
  # has_many :subscriptions
  has_one :account # Stripe account
  has_many :carts
  has_many :phone_codes
  embeds_many :payment_methods # TODO: Agregar esto a stripe
  embeds_many :addresses, as: :model
  #has_many :qr

  # Validations
  # validates :name, presence: true, format: {with: /\A[a-zA-ZáéíóúñÁÉÍÓÚÑ\s]+\z/}, length: {in: 3..30}
  # validates :lastName, presence: false, format: {with: /\A[a-zA-ZáéíóúñÁÉÍÓÚÑ\s]+\z/}, length: {in: 3..30}, allow_nil: true
  # validates :email, presence: true, uniqueness: {case_sensitive: false, message: "%{value} ya ha sido usado"}
  # validates :name, uniqueness: { scope: :year,
  #                                message: "should happen once per year" }
  validate :valid_phone
  # validates :phone, uniqueness: {case_sensitive: false}, allow_nil: false, phone: {possible: true, types: [:mobile, :voip], countries: :mx}
  # validates :encrypted_password, presence: true


  def valid_phone
    if phone.present?
      unless Phonelib.valid?("+52#{phone}")
        errors.add(:phone, "invalid syntax")
        return false
      end
    else
      errors.add(:phone, "Can't be blank")
      return false
    end
  end

  def current_place
    self.places.last
  end

  # Plugins
  rolify

  aasm column: :status do
    state :pending, initial: true
    state :active
    state :inactive

    event :activate do
      transitions from: [:pending, :inactive], to: :active
    end

    event :deactivate do
      transitions from: [:pending, :active], to: :inactive
    end
  end


  def self.logging_in(g_user, c_user)
    puts "-------------CREANDO"
    g_user.carts.each do |gc|
      puts "-------------CREANDO 11"
      current_cart = c_user.carts.find_by(place: gc.place, status: "pending")
      if current_cart.nil?
        puts "---------EL USER NO TIENE CARRITO DE --- #{gc.place.name}"
        new_cart = c_user.carts.create(place: gc.place, status: "pending")
        gc.cart_items.each do |ci|
          puts "----------AGREGANDO NEW ITEM"
          new_cart.add_item(product: ci.product, place: gc.place, quantity: ci.quantity, aggregates: ci.aggregates)
        end
      else
        gc.cart_items.each do |ci|
          puts "----------AGREGANDO ITEM VIEJO A NUEVO"
          current_cart.add_item(product: ci.product, place: gc.place, quantity: ci.quantity, aggregates: ci.aggregates)
        end
      end
    end
  end


  # return token for client to identify user
  def generate_token
    #Token.generate_token(self.id)
  end


  def current_address
    self.addresses.find_by(current: true) || nil
  end

  def create_and_send_verification_code
    last_phone = get_last_phone_code
    if last_phone.nil?
      phone_code = self.create_verification_code
    else
      phone_code = last_phone
      unless (DateTime.now - 5.minutes) >= phone_code.created_at
        raise "Usa el último código de activación que se envío a #{self.phone}"
      end
    end

    if Rails.env != "test"
      SendWhatsAppMessageJob.perform_now(message: User.text_code_message(code: phone_code.verification_code), phone: self.phone)
    end
    return phone_code
  end

  def get_last_phone_code
    self.phone_codes.where(status: "unused", :created_at.gte => (DateTime.now - 5.minutes)).order(created_at: "desc").limit(1).to_a.first
  end

  def self.text_code_message(code:)
    "Tu código de verificación de waydda es: #{code}"
  end

  def create_verification_code
    self.phone_codes.create(verification_code: PhoneCode.generate_random_number)
  end

  private

  def create_stripe_customer
    CreateStripeCustomerJob.perform_later(self)
  end

  # Assign User default Role
  def assign_default_role
    puts "CREANDO USAURIO"
    add_role(:customer) if roles.blank?
    unless self.phone.blank?
      CreateStripeCustomerJob.perform_later(self)
      puts "ENVIANDO 2"
      self.create_and_send_verification_code
    end
  end


  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"])
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name
      user.photo = auth.info.image # assuming the user model has an image
    end
  end

  # Set required actions for user, like verify email
  def set_required_actions
    # TODO: check what fields change to asign required fields
  end
end
