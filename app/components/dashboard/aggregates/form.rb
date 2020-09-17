class Dashboard::Aggregates::Form < ViewComponent::Base
  def initialize(aggregate:)
    @aggregate = aggregate
  end
end