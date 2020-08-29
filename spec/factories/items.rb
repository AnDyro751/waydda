FactoryBot.define do
  factory :item do
    association :place, factory: :place
  end
end
