class Carts::PaymentMethods::Cash < ViewComponent::Base
  def initialize(place:)
    @place = place
  end
end