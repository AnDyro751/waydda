class Pricing::Item::Index < ViewComponent::Base

  def initialize(place:, name:, current:, description:, with_margin: true, payment_description:, plan_pricing:)
    @place = place
    @name = name
    @current = current
    @description = description
    @with_margin = with_margin
    @payment_description = payment_description
    @plan_pricing = plan_pricing
  end
end