class Dashboard::Orders::Actions < ViewComponent::Base
  # @param [Object] order
  def initialize(order:)
    @order = order
  end
end