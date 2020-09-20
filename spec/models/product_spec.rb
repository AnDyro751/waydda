require 'rails_helper'
RSpec.describe Product, type: :model do
  context "Valid aggregates" do

    let(:place) { FactoryBot.create(:free_valid_place) }
    let(:aggregate_categories_1) { FactoryBot.build(attributes_for(:aggregate_category)) }
    let(:aggregate_categories_2) { FactoryBot.build(attributes_for(:aggregate_category)) }
    let(:product) { FactoryBot.build(:product, place: place, aggregate_categories: [aggregate_categories_1, aggregate_categories_2]) }

    it { expect(product.save).to eq(true) }

  end
end