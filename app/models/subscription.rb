class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :place
  # belongs_to :user

  field :stripe_subscription_id, type: String, default: ""
  field :end_date, type: String, default: ""
  field :start_date, type: String, default: ""
  field :trial_start, type: String, default: ""
  field :trial_end, type: String, default: ""
  field :kind, type: String, default: "free"

  validates :kind, inclusion: {in: %w[free premium]}, presence: true
  validates :stripe_subscription_id, presence: true

end
