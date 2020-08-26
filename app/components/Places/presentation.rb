class Places::Presentation < ViewComponent::Base
  def initialize(delivery_option:, place:, current_cart:)
    @place = place
    @delivery_option = delivery_option
    @current_cart = current_cart
  end
end