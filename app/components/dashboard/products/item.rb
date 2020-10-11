class Dashboard::Products::Item < ViewComponent::Base
  def initialize(product:, place:)
    @product = product
    @place = place
  end
end