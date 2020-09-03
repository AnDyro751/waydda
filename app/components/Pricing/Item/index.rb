class Pricing::Item::Index < ViewComponent::Base

  def initialize(place:, name:, current:, description:, with_margin: true)
    @place = place
    @name = name
    @current = current
    @description = description
    @with_margin = with_margin
  end
end