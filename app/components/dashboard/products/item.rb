class Dashboard::Products::Item < ViewComponent::Base
  def initialize(product:, place:, with_delete: false)
    @product = product
    @place = place
    @with_delete = with_delete
  end
end