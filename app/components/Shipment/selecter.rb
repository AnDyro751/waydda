class Shipment::Selecter < ViewComponent::Base
  # @param [Object] current_address
  def initialize(current_address:)
    @current_address = current_address
  end
end