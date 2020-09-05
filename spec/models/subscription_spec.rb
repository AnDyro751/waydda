require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { is_expected.to have_field(:stripe_subscription_id).of_type(String) }
  it { is_expected.to have_field(:end_date).of_type(String) }
  it { is_expected.to have_field(:start_date).of_type(String) }
  it { is_expected.to have_field(:trial_start).of_type(String) }
  it { is_expected.to have_field(:trial_end).of_type(String) }
  it { is_expected.to have_field(:kind).of_type(String).with_default_value_of("free") }


  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_inclusion_of(:kind).to_allow("free", "premium") }

end
