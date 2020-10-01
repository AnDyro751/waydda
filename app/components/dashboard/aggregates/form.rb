class Dashboard::Aggregates::Form < ViewComponent::Base
  def initialize(aggregate:, product:, aggregate_category:, small: false)
    @aggregate = aggregate
    @aggregate_category = aggregate_category
    @product = product
    @small = small
  end
end