class Places::DeliveryModal < ViewComponent::Base
  # @param [Object] message
  def initialize(message: "")
    @message = message
  end
end