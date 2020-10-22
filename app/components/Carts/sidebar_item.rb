class Carts::SidebarItem < ViewComponent::Base
  def initialize(cart_item:, place:)
    @cart_item = cart_item
    @place = place
  end
end