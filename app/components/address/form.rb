class Address::Form < ViewComponent::Base
  def initialize(address:)
    @address = address
  end
end