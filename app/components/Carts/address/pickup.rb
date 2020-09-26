class Carts::Address::Pickup < ViewComponent::Base
  def initialize(place:)
    @place = place
  end
end