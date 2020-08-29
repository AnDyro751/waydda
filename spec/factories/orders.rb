FactoryBot.define do
  factory :order do
    association :place, factory: :place
  end
end
