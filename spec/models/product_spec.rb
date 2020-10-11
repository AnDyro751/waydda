require 'rails_helper'
RSpec.describe Product, type: :model do

  describe "Fields model" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should have_field(:name).of_type(String) }
    it { should have_field(:description).of_type(String) }
    it { should have_field(:price).of_type(Float).with_default_value_of(0) }
    it { should have_field(:slug).of_type(String) }
    it { should have_field(:unlimited).of_type(Mongoid::Boolean) }
    it { should have_field(:status).of_type(String) }
    it { should have_field(:photo).of_type(String).with_default_value_of("places/default.png") }
    it { should have_field(:sku).of_type(String) }
    it { should have_field(:weight).of_type(Float) }
    it { should belong_to(:place).of_type(Place) }
    it { should have_and_belong_to_many(:items) }
    it { should accept_nested_attributes_for(:aggregate_categories) }

    it { should validate_length_of(:name).within(4..30) }
    it { should validate_numericality_of(:price).greater_than(0) }
    it { should validate_inclusion_of(:status).to_allow("active", "inactive") }
    it { should validate_inclusion_of(:unlimited).to_allow(true, false) }
    it { should validate_numericality_of(:quantity).greater_than(0) }
    it { should validate_inclusion_of(:quantity_measure).to_allow("kg", "grm", "oz", "ml", "l", "m2", "m3", "pzas") }

  end
  context "Valid aggregates" do

    let(:place) { FactoryBot.create(:free_valid_place) }
    let(:product) { FactoryBot.build(:product, place: place) }
    let(:valid_product) { FactoryBot.create(:product, place: place) }
    let(:aggregate_categories_1) { FactoryBot.build(:aggregate_category, product: product) }
    let(:aggregate_categories_2) { FactoryBot.build(:aggregate_category, product: product) }
    let(:aggregate_categories_3_not_required) { FactoryBot.build(:aggregate_category, product: product, required: false) }


    it 'should be not save' do
      product.status = "demo"
      expect(product.save).to eq(false)
    end
    it 'should be save product' do
      current_save = product.save
      expect(current_save).to eq(true)
    end
    context "Product saved" do

      it { expect(product.aggregate_categories.size).to eq(0) }
      it 'should be add aggregate_categories' do
        valid_product.aggregate_categories << aggregate_categories_1
        valid_product.aggregate_categories << aggregate_categories_2
        expect(valid_product.aggregate_categories.size).to eq(2)
      end
      describe "with Aggregates" do
        before(:each) {
          valid_product.aggregate_categories << aggregate_categories_1
          valid_product.aggregate_categories << aggregate_categories_2
          valid_product.aggregate_categories << aggregate_categories_3_not_required
        }

        it 'should be get 3 aggregate_categories' do
          expect(valid_product.aggregate_categories.size).to eq(3)
        end

        it 'should be return false in valid_sale?' do
          valid_product.update(unlimited: false)
          valid_product.reload
          expect { valid_product.valid_sale?(quantity: 4) }.to raise_error(RuntimeError)
        end

        it 'should be return false when unlimited is false and intent buy -1 item' do
          valid_product.update(unlimited: false)
          expect { valid_product.reload.valid_sale?(quantity: -1) }.to raise_error(RuntimeError)
        end

        it { expect { valid_product.valid_sale?(quantity: 0) }.to raise_error(RuntimeError) }

        it 'should be return true when public stock is zero and unlimited is true' do
          valid_product.update(unlimited: true)
          expect(valid_product.reload.valid_sale?(quantity: 1)).to eq(true)
        end

        it 'should be return false in valid_sale? when unlimited is false and public_stock is 3 and intent buy 4 items' do
          valid_product.update(public_stock: 3, unlimited: false)
          expect { valid_product.reload.valid_sale?(quantity: 4) }.to raise_error(RuntimeError)
        end

        it 'should be return true in valid_sale? when unlimited is false and public_stock is 3 and intent buy 3 items' do
          valid_product.update(public_stock: 3, unlimited: false)
          expect(valid_product.reload.valid_sale?(quantity: 3)).to eq(true)
        end
      end

      describe "Valid aggregations" do
        before(:each) {
          valid_product.aggregate_categories << aggregate_categories_1
          valid_product.aggregate_categories << aggregate_categories_2
          valid_product.aggregate_categories << aggregate_categories_3_not_required
        }

        before(:each) {
          aggregate_categories_1.aggregates.new(attributes_for :aggregate)
          aggregate_categories_1.aggregates.new(attributes_for :aggregate)
          aggregate_categories_2.aggregates.new(attributes_for :aggregate)
          aggregate_categories_2.aggregates.new(attributes_for :aggregate)
        }

        let(:valid_params) {
          [
              {
                  id: aggregate_categories_1.id.to_s,
                  subvariants: AggregateCategory.get_ids(items: aggregate_categories_1.aggregates)
              },
              {
                  id: aggregate_categories_2.id.to_s,
                  subvariants: AggregateCategory.get_ids(items: aggregate_categories_2.aggregates)
              },
              {
                  id: aggregate_categories_3_not_required.id.to_s,
                  subvariants: AggregateCategory.get_ids(items: aggregate_categories_3_not_required.aggregates)
              }
          ]
        }

        it { expect(aggregate_categories_1.aggregates.size).to eq(2) }
        it { expect(aggregate_categories_2.aggregates.size).to eq(2) }
        it { expect(aggregate_categories_3_not_required.aggregates.size).to eq(0) }

        it 'should be return false because one id is incorrect' do
          aggregates = [{id: "false_id"}, {id: aggregate_categories_3_not_required}]
          expect { valid_product.valid_aggregates_sale?(aggregates: aggregates) }.to raise_error(RuntimeError)
        end

        it 'should be return false in valid_aggregates_sale when product is inactive' do
          aggregates = [{id: aggregate_categories_1}, {id: aggregate_categories_2}, {id: aggregate_categories_3_not_required}]
          expect { valid_product.valid_aggregates_sale?(aggregates: aggregates) }.to raise_error(RuntimeError)
        end

        it 'should be true' do
          expect(valid_product.valid_aggregates_sale?(aggregates: valid_params)).to eq(true)
        end


      end

    end
  end
end