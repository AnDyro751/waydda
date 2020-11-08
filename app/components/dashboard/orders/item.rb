class Dashboard::Orders::Item < ViewComponent::Base
  def initialize(order_item:)
    @order_item = order_item
  end
end