FactoryBot.define do
  factory :place do
    sequence(:name) { |n| "Place #{n}" }
    sequence(:address) { |n| "Address Place #{n}" }
    association :user, factory: :user
    slug { "demo-place-slug" }
  end

end
