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

end
