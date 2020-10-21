class Places::DeliveryModal < ViewComponent::Base
  # @param [Object] message
  def initialize(message: "", current_user:, available_distance: false, current_cart:)
    @message = message
    @current_user = current_user
    @available_distance = available_distance
    @current_cart = current_cart
  end
end