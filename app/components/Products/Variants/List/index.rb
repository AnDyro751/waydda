class Products::Variants::List::Index < ViewComponent::Base
  # @param [Object] product
  def initialize(product:, f:)
    @product = product
    @f = f
  end
end