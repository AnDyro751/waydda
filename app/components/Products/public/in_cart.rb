class Products::Public::InCart < ViewComponent::Base
  def initialize(cart_item:, place:)
    @place = place
    @cart_item = cart_item
  end
end