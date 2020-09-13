class Products::Item < ViewComponent::Base
  def initialize(product:)
    @product = product
  end
end