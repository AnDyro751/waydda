class Carts::Address::Delivery < ViewComponent::Base
  def initialize(place:)
    @place = place
  end
end