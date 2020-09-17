class Dashboard::Aggregates::List < ViewComponent::Base
  # @param [ArrayField] aggregates
  def initialize(aggregates:, size: "small")
    @aggregates = aggregates
    @size = size
  end
end