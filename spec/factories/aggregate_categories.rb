FactoryBot.define do
  factory :aggregate_category do
    required { false }
    max_aggregates { "" }
    min_aggregates { "" }
    description { "MyString" }
  end
end
