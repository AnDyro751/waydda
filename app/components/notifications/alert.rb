class Notifications::Alert < ViewComponent::Base
  def initialize(alert:, kind: "success", with_spacing: false)
    @alert = alert
    @kind = kind
    @with_spacing = with_spacing
  end
end