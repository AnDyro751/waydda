class Dashboard::Aggregates::Item < ViewComponent::Base
  def initialize(aggregate:, product:, aggregate_category:)
    @aggregate = aggregate
    @aggregate_category = aggregate_category
    @product = product
  end
end