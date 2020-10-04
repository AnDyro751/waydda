require 'rails_helper'

RSpec.describe Cart, type: :model do

  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }

  it {
    is_expected.to have_field(:quantity).of_type(Integer).with_default_value_of(0)
  }

  it {
    is_expected.to have_field(:payment_type).of_type(String).with_default_value_of("cash")
  }

  it { is_expected.to have_field(:status).of_type(String).with_default_value_of("pending") }
  it { is_expected.to belong_to(:place).of_type(Place) }
  it { is_expected.to belong_to(:user).of_type(User).with_optional }

  it { is_expected.to have_many(:cart_items) }
  it { is_expected.to embed_many(:addresses) }
  it { is_expected.to embed_one(:delivery_option) }
  it { is_expected.to embed_one(:checkout) }

  it { is_expected.to validate_inclusion_of(:payment_type).to_allow("card", "cash") }
  it { is_expected.to validate_inclusion_of(:status).to_allow("pending", "success") }
  it { is_expected.to validate_presence_of(:status) }

  context "# Create cart" do
    let(:place) { FactoryBot.create(:free_valid_place) }
    let(:cart) { FactoryBot.build(:cart_without_associations, place: place) }
    let(:persisted_cart) { FactoryBot.create(:cart_without_associations, place: place) }
    let(:product) { FactoryBot.create(:product, place: place) }
    describe "Save cart" do

      it "not should be save a cart" do
        cart.status = "demo"
        expect(cart.save).to eq(false)
      end

      it { expect(cart.save).to eq(true) }
    end

    describe "Cart items" do
      let(:cart_item) { cart.cart_items.build(attributes_for(:cart_item, cart: cart)) }

      it 'should be get zero cart_items' do
        expect(cart.cart_items.size).to eq(0)
      end

      it { expect(cart_item.save).to eq(false) }

      it 'should be save cart_item' do
        cart_item.product = product
        expect(cart_item.save).to eq(true)
      end

    end

    describe "Add product to cart" do

      let(:aggregate_categories_1) { FactoryBot.create(:aggregate_category, product: product) }
      let(:aggregate_categories_2) { FactoryBot.create(:aggregate_category, product: product) }
      let(:aggregate_categories_3_not_required) { FactoryBot.create(:aggregate_category, product: product, required: false) }

      before(:each) {
        product.aggregate_categories << aggregate_categories_1
        product.aggregate_categories << aggregate_categories_2
        product.aggregate_categories << aggregate_categories_3_not_required
      }

      before(:each) {
        aggregate_categories_1.aggregates << FactoryBot.create(:aggregate, aggregate_category: aggregate_categories_1, name: "Demo 1")
        aggregate_categories_1.aggregates << FactoryBot.create(:aggregate, aggregate_category: aggregate_categories_1, name: "Demo 2")
        aggregate_categories_2.aggregates << FactoryBot.create(:aggregate, aggregate_category: aggregate_categories_2)
        aggregate_categories_2.aggregates << FactoryBot.create(:aggregate, aggregate_category: aggregate_categories_2)
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

      it { expect(persisted_cart.save).to eq(true) }

      it 'should be return raise in add product to add cart function' do
        expect { persisted_cart.add_item(product: product, place: place, quantity: 1, aggregates: []) }.to raise_error(RuntimeError)
      end

      it 'should be return true in add product to add cart function' do
        expect(persisted_cart.add_item(product: product, place: place, quantity: 1, aggregates: valid_params)).to eq(true)
      end

      it 'should be return raise in add product to add cart function because product is inactive' do
        product.update(status: "inactive")
        expect { persisted_cart.add_item(product: product.reload, place: place, quantity: 1, aggregates: valid_params) }.to raise_error
      end

      it { expect(persisted_cart.cart_items.size).to be(0) }

      it 'crete_or_update_cart_item should be return true' do
        expect(persisted_cart.create_or_update_cart_item(product: product, aggregates: [])).to be(true)
      end

      it 'expect one cart item' do
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        expect(persisted_cart.reload.cart_items.size).to be(1)
      end

      it 'expect 1 items in cart quantity' do
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        expect(persisted_cart.reload.quantity).to be(1)
      end

      it 'expect 2 items in cart quantity' do
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        expect(persisted_cart.reload.quantity).to be(2)
      end


      it 'expect 1 items in cart_item quantity' do
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        expect(persisted_cart.reload.cart_items.last.quantity).to be(1)
      end


      it 'expect 2 items in cart_item quantity' do
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        expect(persisted_cart.reload.cart_items.last.quantity).to be(2)
      end

      it 'should be return true when cart_item is updated and -1 and force update is true' do
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        persisted_cart.reload.cart_items.last.update_quantity(quantity: 1, force: true, add: false)
        expect(persisted_cart.reload.cart_items.last.quantity).to be(1)
      end

      it 'should be 1 when cart_item is updated and force is false' do
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        persisted_cart.reload.cart_items.last.update_quantity(quantity: 1, force: false, add: false)
        expect(persisted_cart.reload.cart_items.last.quantity).to be(1)
      end


      it 'should be return raise error when the quantity update is greather to public stock' do
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        persisted_cart.create_or_update_cart_item(product: product, aggregates: [])
        expect { persisted_cart.reload.cart_items.last.update_quantity(quantity: 51, force: false, add: false) }.to raise_error(RuntimeError)
      end

    end
  end
end
