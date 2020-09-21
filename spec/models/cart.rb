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
        cart_item.products << product
        expect(cart_item.save).to eq(true)
      end

      it 'should be get 1 record in products relationship' do
        cart_item.products << product
        cart_item.save
        expect(cart_item.products.size).to eq(1)
      end
    end

    describe "Add product to cart" do
      # before(:each) { cart.save }
      # before(:each) { cart_item.save }
      it 'should be add product to cart' do
        expect(cart.save).to eq(true)
        expect(cart.add_item(product: product, place: place, quantity: 1, aggregates: [])).to eq(false)
      end
    end

  end
end
