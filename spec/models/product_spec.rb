require 'rails_helper'
RSpec.describe Product, type: :model do
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
          expect(valid_product.valid_sale?(quantity: 4)).to eq(false)
        end

        it 'should be return false when unlimited is false and intent buy -1 item' do
          valid_product.update(unlimited: false)
          expect(valid_product.reload.valid_sale?(quantity: -1)).to eq(false)
        end

        it { expect(valid_product.valid_sale?(quantity: 0)).to eq(false) }

        it 'should be return true when public stock is zero and unlimited is true' do
          valid_product.update(unlimited: true)
          expect(valid_product.reload.valid_sale?(quantity: 1)).to eq(true)
        end

        it 'should be return false in valid_sale? when unlimited is false and public_stock is 3 and intent buy 4 items' do
          valid_product.update(public_stock: 3, unlimited: false)
          expect(valid_product.reload.valid_sale?(quantity: 4)).to eq(false)
        end

        it 'should be return true in valid_sale? when unlimited is false and public_stock is 3 and intent buy 3 items' do
          valid_product.update(public_stock: 3, unlimited: false)
          expect(valid_product.reload.valid_sale?(quantity: 3)).to eq(true)
        end

      end
    end


  end
end