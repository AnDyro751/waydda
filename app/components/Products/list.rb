class Products::List < ViewComponent::Base
  def initialize(products:, in_dashboard: false, place: nil, with_delete: false)
    @products = products
    @in_dashboard = in_dashboard
    @place = place
    @with_delete = with_delete
  end
end