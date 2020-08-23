class Places::Menu < ViewComponent::Base
  def initialize(delivery_option:, place:)
    @delivery_option = delivery_option
    @place = place
  end
end