class Dashboard::Orders::ShowMap < ViewComponent::Base
  # @param [Object] order
  def initialize(order:, place:)
    @order = order
    @place = place
  end
end