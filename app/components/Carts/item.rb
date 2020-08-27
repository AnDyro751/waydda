class Carts::Item < ViewComponent::Base
  # @param [Object] cart_item
  def initialize(cart_item:)
    @cart_item = cart_item
  end
end