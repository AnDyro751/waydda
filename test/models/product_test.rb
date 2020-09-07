require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to have_field(:description).of_type(String) }
  it { is_expected.to have_field(:price).of_type(Float) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:price) }

end
