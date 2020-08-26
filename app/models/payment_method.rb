class PaymentMethod
  include Mongoid::Document
  include Mongoid::Timestamps

  field :last_4, type: String

  embedded_in :user
end
