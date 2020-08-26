class Carts::Form < ViewComponent::Base
  # @param [Object] cart_items
  # @param [Object] place
  # @param [Object] current_cart
  # @param [Float] total
  def initialize(cart_items:, place:, current_cart:, total:)
    @cart_items = cart_items
    @place = place
    @current_cart = current_cart
    @total = total
  end
end