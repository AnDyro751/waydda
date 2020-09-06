class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :place
  Stripe.api_key = 'sk_test_51H9CZeBOcPJ0nbHctTzfQZhFXBnn8j05e0xqJ5RSVz5Bum72LsvmQKIecJnsoHISEg0jUWtKjERYGeCAEWiIAujP00Fae9MiKm'

  # belongs_to :user

  field :stripe_subscription_id, type: String, default: ""
  field :end_date, type: String, default: ""
  field :start_date, type: String, default: ""
  field :trial_start, type: String, default: ""
  field :trial_end, type: String, default: ""
  field :kind, type: String, default: "free"

  validates :kind, inclusion: {in: %w[free premium]}, presence: true
  validates :stripe_subscription_id, presence: true

  def self.cancel_subscription(subscription_id)
    begin
      Stripe::Subscription.delete(subscription_id.to_s)
      return true
    rescue => e
      puts "-------#{e} CANCEL SUB #{subscription_id}"
      return false
    end
  end

end
