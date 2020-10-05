class Products::Form::HeaderMenu < ViewComponent::Base
  # @param [Object] product
  # @return [Object]
  def initialize(product:)

    @product = product
  end
end