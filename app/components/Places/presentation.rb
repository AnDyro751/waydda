class Places::Presentation < ViewComponent::Base
  def initialize(delivery_option:, place:, current_cart:, items: [], available_distance:)
    @place = place
    @delivery_option = delivery_option
    @current_cart = current_cart
    @items = items
    @available_distance = available_distance
  end
end