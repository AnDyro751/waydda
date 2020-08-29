require 'rails_helper'

RSpec.describe User, type: :model do

  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }
  it { is_expected.to have_many :places }
  it { is_expected.to have_many :carts }
  it { is_expected.to embed_many(:payment_methods) }
  it { is_expected.to embed_many(:addresses) }

  # Fields
  describe "#name" do
    # Name
    it { is_expected.to have_field(:name).of_type(String) }
    it { is_expected.to validate_length_of(:name).within(3..30) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_format_of(:name).to_allow("Iñaki").not_to_allow("De 12") }
  end
  describe "#lastname" do
    # LastName
    it { is_expected.to have_field(:lastName).of_type(String) }
    it { is_expected.to validate_length_of(:lastName).within(3..30) }
    it { is_expected.to validate_format_of(:lastName).to_allow("Méndez").not_to_allow("De 12") }
  end

  describe '#save' do
    userBot = FactoryBot.build(:user)
    subject(:user) { described_class.new }
    it 'not should be persisted' do
      expect(user.save).to eq false
    end
    it 'should be persisted' do
      expect(userBot.save).to eq true
    end

  end
end
