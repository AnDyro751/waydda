class Places::Presentation < ViewComponent::Base
  def initialize(delivery_option:, place:)
    @place = place
    @delivery_option = delivery_option
  end
end