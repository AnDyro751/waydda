class Carts::Address::Delivery < ViewComponent::Base
  def initialize(place:, address:)
    @place = place
    @address = address
  end
end