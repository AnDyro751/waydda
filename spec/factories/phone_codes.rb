FactoryBot.define do
  factory :phone_code do
    verification_code { "MyString" }
    exp_date { "MyString" }
  end
end
