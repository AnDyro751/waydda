FactoryBot.define do
  factory :place do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
    sequence(:address) { |n| "#{Faker::Address.street_name} #{n}" }
    association :user, factory: :user
    slug { "demo-place-slug" }
  end

end
