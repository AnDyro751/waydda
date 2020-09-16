class Dashboard::List::Index < ViewComponent::Base
  def initialize(items:, title:)
    @items = items
    @title = title
  end
end