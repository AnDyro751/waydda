class Products::Public::List < ViewComponent::Base
  def initialize(products:, place:)
    @place = place
    @products = products
  end
end