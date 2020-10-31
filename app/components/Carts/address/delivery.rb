class Carts::Address::Delivery < ViewComponent::Base
  def initialize(place:, address:, editable: true, current_cart: nil)
    @place = place
    @address = address
    @editable = editable
    @current_cart = current_cart
  end
end