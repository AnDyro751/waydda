FactoryBot.define do
  factory :product do
    id { SecureRandom.uuid }
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.sentence }
    price { 50 }
    public_stock { 50 }
    status { "active" }
    slug { "demo-product-slug" }
    unlimited { true }
    # association :place, factory: :place
  end
end
