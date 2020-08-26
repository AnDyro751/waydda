class Carts::Sidebar < ViewComponent::Base
  # @param [Object] place
  # @param [Object] total
  def initialize(place:, total:)
    @place = place
    @total = total
  end
end