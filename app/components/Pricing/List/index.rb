class Pricing::List::Index < ViewComponent::Base
  def initialize(place:, pricing:, with_margin: true)
    @pricing = pricing
    @place = place
    @with_margin = with_margin
  end
end