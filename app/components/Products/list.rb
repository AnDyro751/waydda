class Products::List < ViewComponent::Base
  def initialize(products:, in_dashboard: false, place: nil)
    @products = products
    @in_dashboard = in_dashboard
    @place = place
  end
end