require 'rails_helper'

RSpec.describe AggregateCategory, type: :model do
  it { should have_field(:name).of_type(String) }
  it { should have_field(:multiple_selection).of_type(Mongoid::Boolean).with_default_value_of(false) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).within(2..40) }
  it { should validate_presence_of(:required) }
  it { should validate_inclusion_of(:required).to_allow(true, false) }
  it { should validate_presence_of(:multiple_selection) }

  it { should be_embedded_in(:product) }
  it { should embed_many(:aggregates) }
  it { should accept_nested_attributes_for(:aggregates) }

  context "Save record" do
    let(:user) { FactoryBot.create(:user) }
    let(:place) { FactoryBot.create(:free_valid_place, user: user) }
    let(:product) { FactoryBot.create(:product, place: place) }
    let(:aggregate_category) { product.aggregate_categories.new(attributes_for :aggregate_category, product: product) }

    describe "save aggregate category" do
      it { expect(aggregate_category.save).to eq(true) }
      it { expect(aggregate_category.name).to eq("Aggregate Category") }
      it { expect(aggregate_category.required).to eq(true) }
      it { expect(aggregate_category.multiple_selection).to eq(true) }
    end

  end
end
