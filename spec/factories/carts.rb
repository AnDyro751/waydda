FactoryBot.define do
  factory :cart do
    association :place, factory: :place
    association :user, factory: :user
  end
end
