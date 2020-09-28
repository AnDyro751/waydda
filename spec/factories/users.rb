FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Nombre" }
    sequence(:lastName) { |n| "Last Name" }
    email { Faker::Internet.email }
    phone { "9516074586" }
    password { '123456' }
    encrypted_password { '123456' }
    photo { 'waydda.png' }
  end

end
