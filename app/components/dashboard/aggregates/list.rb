class Dashboard::Aggregates::List < ViewComponent::Base
  # @param [ArrayField] aggregates
  def initialize(aggregates:, size: "small", product:)
    @aggregates = aggregates
    @size = size
    @product = product
  end
end