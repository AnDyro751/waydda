class DeliveryOption
  include Mongoid::Document
  include Mongoid::Timestamps

  field :kind, type: String, default: "delivery"

  embedded_in :cart

  validates :kind, inclusion: %w[delivery pickup]
end
