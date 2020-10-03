class Dashboard::Sidebar::Item < ViewComponent::Base
  def initialize(text:, to:, active_controller:, active_actions: nil)
    @text = text
    @to = to
    @active_controller = active_controller
    @active_actions = active_actions
  end
end