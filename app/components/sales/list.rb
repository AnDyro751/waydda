class Sales::List < ViewComponent::Base
  def initialize(sales:, place:)
    @sales = sales
    @place = place
  end
end