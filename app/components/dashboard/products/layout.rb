class Dashboard::Products::Layout < ViewComponent::Base
  def initialize(product:, full_page: false)
    @product = product
    @full_page = full_page
  end
end