class Dashboard::AggregateCategories::List::Simple < ViewComponent::Base

  def initialize(product:, aggregate_category:, f:)
    @product = product
    @aggregate_category = aggregate_category
    @f = f
  end

end