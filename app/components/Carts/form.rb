class Carts::Form < ViewComponent::Base
  # @param [Object] cart_items
  # @param [Object] place
  # @param [Object] current_cart
  # @param [Float] total
  # @param [Object] current_address
  def initialize(cart_items:, place:, current_cart:, total:, current_user:, current_address:, address:, available_distance:)
    @cart_items = cart_items
    @place = place
    @current_cart = current_cart
    @total = total
    @current_user = current_user
    @current_address = current_address
    @address = address
    @available_distance = available_distance
  end
end