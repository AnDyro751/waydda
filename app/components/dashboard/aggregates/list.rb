class Dashboard::Aggregates::List < ViewComponent::Base
  # @param [ArrayField] aggregates
  def initialize(aggregates:)
    @aggregates = aggregates
  end
end