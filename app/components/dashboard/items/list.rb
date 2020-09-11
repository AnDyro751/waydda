class Dashboard::Items::List < ViewComponent::Base
  # @param [ArrayField] items
  def initialize(items:)
    @items = items
  end
end