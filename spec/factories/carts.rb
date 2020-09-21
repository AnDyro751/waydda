FactoryBot.define do
  factory :cart_without_associations, class: Cart do
    # association :place, factory: :place
    # association :user, factory: :user
    quantity { 0 }
    payment_type { "cash" }
    status { "pending" }
  end
end
