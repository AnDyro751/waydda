class Places::Menu < ViewComponent::Base
  def initialize(delivery_option:, place:, current_cart:,size: "small")
    @current_cart = current_cart
    @delivery_option = delivery_option
    @place = place
    @size = size
  end
end