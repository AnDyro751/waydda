FactoryBot.define do
  factory :cart_item do
    association :product, factory: :product
    association :cart, factory: :cart
  end
end
