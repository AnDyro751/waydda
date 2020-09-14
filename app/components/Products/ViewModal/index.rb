class Products::ViewModal::Index < ViewComponent::Base
  def initialize(product:)
    @product = product
  end
end