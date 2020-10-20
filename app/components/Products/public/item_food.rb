class Products::Public::ItemFood < ViewComponent::Base
  # @param [Object] product
  # @param [Object] place
  # @return [Object]
  def initialize(product:, place:)
    @place = place
    @product = product
  end
end