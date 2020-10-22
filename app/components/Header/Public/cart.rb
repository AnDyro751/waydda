class Header::Public::Cart < ViewComponent::Base
  # @param [Object] current_cart
  def initialize(current_cart:, cart_items:, place: nil)
    @current_cart = current_cart
    @cart_items = cart_items
    @place = place
  end
end