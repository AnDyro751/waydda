class Products::Item < ViewComponent::Base
  def initialize(product:, in_dashboard: false, place: nil)
    @product = product
    @in_dashboard = in_dashboard
    @place = place
  end
end