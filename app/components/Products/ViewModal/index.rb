class Products::ViewModal::Index < ViewComponent::Base
  def initialize(product:, place:)
    @product = product
    @place = place
  end
end