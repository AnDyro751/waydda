class Carts::Address::Pickup < ViewComponent::Base
  def initialize(place:, available_distance:)
    @place = place
    @available_distance = available_distance
  end
end