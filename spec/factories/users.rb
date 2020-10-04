FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    sequence(:name) { |n| "Nombre" }
    sequence(:lastName) { |n| "Last Name" }
    email { Faker::Internet.email }
    phone { "9516074586" }
    password { '123456' }
    encrypted_password { '123456' }
    photo { 'waydda.png' }
    factory :user_with_place do
      after(:create) do |user|
        create_list(:place, 1, user: user)
      end
    end
  end


end
