class Dashboard::Orders::Info < ViewComponent::Base
  # @param [Object] order
  def initialize(order:)
    @order = order
  end
end