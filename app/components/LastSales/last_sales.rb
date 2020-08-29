class LastSales::LastSales < ViewComponent::Base
  def initialize(message:, orders:)
    @message = message
    @orders = orders
  end
end