class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include AASM
  include GlobalID::Identification

  devise :database_authenticatable, :registerable, :omniauthable, :rememberable, omniauth_providers: [:facebook, :google_oauth2]
  # Callbacks
  after_create :assign_default_role
  after_create :create_stripe_customer
  # TODO: Al registrarse y si ya cuenta con un carrito se debe hacer merge
  # after_create :merge_cart

  # Fields
  field :name, type: String
  field :lastName, type: String
  field :email, type: String
  field :requiredActions, type: Array
  field :phone, type: String
  field :encrypted_password, type: String
  field :status, type: String
  field :photo, type: String, default: "waydda.png"
  field :timezone, type: String
  field :remember_created_at, type: DateTime
  field :is_admin, type: Boolean, default: false
  field :pricing_selected, type: String # El precio que seleccionó al registrarse
  field :stripe_customer_id, type: String, default: ""

  # OMNIAUTH
  field :provider, type: String
  field :uid, type: String
  field :password_changed, type: Boolean, default: false

  # Relations
  has_many :places
  has_one :account # Stripe account
  has_many :carts
  embeds_many :payment_methods # TODO: Agregar esto a stripe
  embeds_many :addresses, as: :model
  #has_many :qr

  # Validations
  validates :name, presence: true, format: {with: /\A[a-zA-ZáéíóúñÁÉÍÓÚÑ\s]+\z/}, length: {in: 3..30}
  validates :lastName, presence: false, format: {with: /\A[a-zA-ZáéíóúñÁÉÍÓÚÑ\s]+\z/}, length: {in: 3..30}, allow_nil: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validate :valid_email
  validates :phone, uniqueness: {case_sensitive: false}, allow_nil: true, phone: {possible: true, types: :mobile, countries: :mx}


  def valid_email
    if email.present?
      unless EmailAddress.valid? email, host_validation: :syntax
        errors.add(:email, "invalid syntax")
      end
    else
      errors.add(:email, "Can't be blank")
    end
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


  # return token for client to identify user
  def generate_token
    #Token.generate_token(self.id)
  end


  def current_address
    self.addresses.find_by(current: true) || nil
  end

  private

  def create_stripe_customer
    CreateStripeCustomerJob.perform_later(self)
  end

  # Assign User default Role
  def assign_default_role
    add_role(:customer) if roles.blank?
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
