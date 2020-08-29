class Header::Public::Cart < ViewComponent::Base
  # @param [Object] current_cart
  def initialize(current_cart:)
    @current_cart = current_cart
  end
end