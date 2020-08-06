class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include AASM

  devise :database_authenticatable, :registerable
  # Callbacks
  after_create :assign_default_role
  after_create :set_required_actions
  after_update :set_required_actions

  # Fields
  field :name, type: String
  field :lastName, type: String
  field :email, type: String
  field :requiredActions, type: Array
  field :phone, type: String
  field :encrypted_password, type: String
  field :status, type: String
  # Relations
  has_many :places
  #has_many :qr

  # Validations
  validates :name, presence: true, format: { with: /\A[a-zA-ZáéíóúñÁÉÍÓÚÑ\s]+\z/ }, length: { in: 3..20 }
  validates :lastName, presence: false, format: { with: /\A[a-zA-ZáéíóúñÁÉÍÓÚÑ\s]+\z/ }, length: { in: 3..20 }, allow_nil: true
  validates :email, presence: true, uniqueness: { case_sensitive: false  }
  validates_with EmailAddress::ActiveRecordValidator, field: :email
  validates :phone, uniqueness: { case_sensitive: false }, allow_nil: true, phone: { possible: true, types: :mobile, countries: :mx }

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

  private

  # Assign User default Role
  def assign_default_role
    add_role(:customer) if roles.blank?
  end

  # Set required actions for user, like verify email
  def set_required_actions
    # TODO: check what fields change to asign required fields
  end
end
