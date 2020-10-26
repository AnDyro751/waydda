class Dashboard::Products::Layout < ViewComponent::Base
  def initialize(product:, full_page: false, custom_record: nil, controller_name: nil, action_name:)
    @product = product
    @full_page = full_page
    @custom_record = custom_record
    @controller_name = controller_name
    @action_name = action_name
  end
end