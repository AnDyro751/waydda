class Carts::Sidebar < ViewComponent::Base
  # @param [Object] place
  # @param [Object] total
  # @param [Object] current_cart
  def initialize(place:, total:, current_cart:)
    @place = place
    @total = total
    @current_cart = current_cart
  end
end