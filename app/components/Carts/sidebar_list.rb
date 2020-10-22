class Carts::SidebarList < ViewComponent::Base

  def initialize(cart_items:, place:, total:, current_cart:)
    @place = place
    @cart_items = cart_items
    @total = total
    @current_cart = current_cart
  end

end