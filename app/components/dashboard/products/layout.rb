class Dashboard::Products::Layout < ViewComponent::Base
  def initialize(product:)
    @product = product
  end
end