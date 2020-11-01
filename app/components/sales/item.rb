class Sales::Item < ViewComponent::Base
  def initialize(sale:, place:)
    @sale = sale
    @place = place
  end
end