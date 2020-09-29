class Dashboard::Sidebar::Item < ViewComponent::Base
  def initialize(text:, to:)
    @text = text
    @to = to
  end
end