class Carts::Item < ViewComponent::Base
  # @param [Object] cart_item
  def initialize(cart_item:, place:)
    @cart_item = cart_item
    @place = place
  end
end