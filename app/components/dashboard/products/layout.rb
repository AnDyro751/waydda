class Dashboard::Products::Layout < ViewComponent::Base
  def initialize(product:, full_page: false, custom_record: nil)
    @product = product
    @full_page = full_page
    @custom_record = custom_record
  end
end