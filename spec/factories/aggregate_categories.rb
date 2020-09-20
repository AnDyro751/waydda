FactoryBot.define do
  factory :aggregate_category do
    required { true }
    name { "Name del aggregate" }
    description { "MyString" }
    multiple_selection { true }
    aggregates { [association(:aggregate)] }
  end
end
