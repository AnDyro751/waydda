class Carts::TotalList < ViewComponent::Base
  def initialize(place:, current_cart:, total:)
    @total = total
    @current_cart = current_cart
    @place = place
  end
end