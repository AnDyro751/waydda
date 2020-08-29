FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.sentence }
    price { 50 }
    slug { "demo-product-slug" }
    association :item, factory: :item
    association :place, factory: :place
    association :cart_item, factory: :cart_item
  end
end
