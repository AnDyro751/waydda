class Dashboard::Sidebar::Item < ViewComponent::Base
  def initialize(text:, to:, active_controller:)
    @text = text
    @to = to
    @active_controller = active_controller
  end
end