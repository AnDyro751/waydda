class Products::PublicItem < ViewComponent::Base
  # @param [Object] product
  def initialize(product:)
    @product = product
  end
end