require 'rails_helper'
RSpec.describe Place, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }

  # Fields
  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to have_field(:address).of_type(String) }
  it { is_expected.to have_field(:slug).of_type(String) }
  it { is_expected.to have_field(:status).of_type(String) }
  it { is_expected.to have_field(:lat).of_type(Float) }
  it { is_expected.to have_field(:lng).of_type(Float) }
  it { is_expected.to have_field(:photo).of_type(String).with_default_value_of("places/default.png") }
  it { is_expected.to have_field(:cover).of_type(String).with_default_value_of("waydda.png") }
  it { is_expected.to have_field(:total_items).of_type(Integer).with_default_value_of(0) }
  it { is_expected.to have_field(:total_products).of_type(Integer).with_default_value_of(0) }
  it { is_expected.to have_field(:delivery_option).of_type(Mongoid::Boolean).with_default_value_of(false) }
  it { is_expected.to have_field(:delivery_cost).of_type(Float).with_default_value_of(10) }
  it { is_expected.to have_field(:delivery_distance).of_type(Float).with_default_value_of(5) }
  it { is_expected.to have_field(:delivery_extra_cost).of_type(Float).with_default_value_of(0) }

  # Relations

  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).within(4..30) }
  end

  describe "#address" do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_length_of(:address).within(4..100) }
  end

  describe "#status" do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_inclusion_of(:status).to_allow("pending", "active", "inactive") }
  end

end