class Dashboard::AggregateCategories::List::Simple < ViewComponent::Base

  def initialize(product:, aggregate_category:)
    @product = product
    @aggregate_category = aggregate_category
  end

end