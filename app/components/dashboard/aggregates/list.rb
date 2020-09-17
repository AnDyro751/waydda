class Dashboard::Aggregates::List < ViewComponent::Base
  # @param [ArrayField] aggregates
  def initialize(aggregates:, size: "small", product:, aggregate_category:)
    @aggregates = aggregates
    @size = size
    @product = product
    @aggregate_category = aggregate_category
  end
end