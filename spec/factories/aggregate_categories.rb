FactoryBot.define do
  factory :aggregate_category do
    name { "Aggregate Category" }
    description { Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4) }
    required { true }
    multiple_selection { true }
  end
end
