class LastSales::LastSales < ViewComponent::Base
  def initialize(message:, sales:)
    @message = message
    @sales = sales
  end
end