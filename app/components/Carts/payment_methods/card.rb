class Carts::PaymentMethods::Card < ViewComponent::Base
  def initialize(place:)
    @place = place
  end
end