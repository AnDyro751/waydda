class Address::Form < ViewComponent::Base
  def initialize(address:, page_type: nil)
    @address = address
    @page_type = page_type
  end
end