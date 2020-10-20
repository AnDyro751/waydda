class Places::Presentation < ViewComponent::Base
  def initialize(delivery_option:, place:, current_cart:, items: [], available_distance:, with_cover: true)
    @place = place
    @delivery_option = delivery_option
    @current_cart = current_cart
    @items = items
    @available_distance = available_distance
    @with_cover = with_cover
  end
end