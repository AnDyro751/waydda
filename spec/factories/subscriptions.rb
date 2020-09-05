FactoryBot.define do
  factory :subscription do
    association :place, factory: place
    association :user, factory: user
    stripe_subscription_id { "demo_stripe_id" }
    end_date { "" }
    start_date { "" }
    trial_start { "" }
    trial_end { "" }
    kind { "free" }
  end
end
