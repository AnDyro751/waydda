class Dashboard::Aggregates::New < ViewComponent::Base
  def initialize(aggregate_category:, aggregate:)
    @aggregate = aggregate
    @aggregate_category = aggregate_category
  end
end