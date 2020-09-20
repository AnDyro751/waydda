FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.sentence }
    price { 50 }
    status { "pending" }
    slug { "demo-product-slug" }
    # association :place, factory: :place
  end
end
