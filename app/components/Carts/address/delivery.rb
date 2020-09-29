class Carts::Address::Delivery < ViewComponent::Base
  def initialize(place:, address:, editable: true)
    @place = place
    @address = address
    @editable = editable
  end
end