FactoryBot.define do
  factory :place do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
    sequence(:address) { |n| "#{Faker::Address.street_name} #{n}" }
    association :user, factory: :user
    slug { "demo-place-slug" }
  end

  factory :free_valid_place, class: Place do
    name { Faker::Company.name }
    sequence(:address) { |n| "#{Faker::Address.street_name} #{n}" }
    association :user, factory: :user
    slug { "free-place-slug" }
    status { "active" }
  end

end
