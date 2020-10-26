class Dashboard::Products::Aggregates::List < ViewComponent::Base
  def initialize(aggregate_category:, aggc:)
    @aggregate_category = aggregate_category
    @aggc = aggc
  end
end