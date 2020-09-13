class Products::List < ViewComponent::Base
  def initialize(products:)
    @products = products
  end
end