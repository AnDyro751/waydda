class Dashboard::Orders::ShowMap < ViewComponent::Base
  # @param [Object] order
  def initialize(order:)
    @order = order
  end
end