class LastSales::LastSales < ViewComponent::Base
  def initialize(message:, orders:,place:)
    @message = message
    @orders = orders
    @place = place
  end
end