class Products::Public::ItemNormal < ViewComponent::Base
  def initialize(product:, place:)
    @place = place
    @product = product
  end
end