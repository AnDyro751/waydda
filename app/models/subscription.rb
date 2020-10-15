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


  def self.update_place_subscription(subscription_id, params)
    current_subscription = Subscription.find_by(stripe_subscription_id: subscription_id)
    return false if current_subscription.nil?
    current_place = current_subscription.place
    return false if current_place.nil?
    return current_place.update(params)
  end

  def self.update_subscription_plan(data)
    subscription = Subscription.find_by(stripe_subscription_id: data["id"])
    puts "--------------SUB--------#{subscription}--------#{data["id"]}"
    return nil if subscription.nil?
    place = subscription.place
    puts "--------------PLA--------#{place}"
    return nil if place.nil?
    puts "-----------#{data.plan["amount"]} ATTRIBUTES"
    if data.plan["amount"] <= 1
      place.update(kind: "free", in_free_trial: false, trial_used: true)
      subscription.update(kind: "free", trial_end: "", trial_start: "")
      return subscription
    else
      place.update(kind: "premium", in_free_trial: false, trial_used: true)
      subscription.update(kind: "premium", trial_end: "", trial_start: "")
      return subscription
    end
  end


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
