class Dashboard::Items::List < ActionView::Base
  # @param [ArrayField] items
  def initialize(items:)
    @items = items
  end
end