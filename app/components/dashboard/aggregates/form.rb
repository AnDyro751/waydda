class Dashboard::Aggregates::Form < ViewComponent::Base
  def initialize(aggregate:, product:, aggregate_category:)
    @aggregate = aggregate
    @aggregate_category = aggregate_category
    @product = product
  end
end