class Carts::ListItems < ViewComponent::Base
  def initialize(cart_items:, place:)
    @cart_items = cart_items
    @place = place
  end
end