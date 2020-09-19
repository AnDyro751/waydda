FactoryBot.define do
  factory :cart_item do
    association :cart, factory: :cart
  end
end
