class Dashboard::AggregateCategories::List::Index < ViewComponent::Base
  # @param [Object] product
  def initialize(product:)
    @product = product
  end
end