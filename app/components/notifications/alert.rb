class Notifications::Alert < ViewComponent::Base
  def initialize(alert:, kind: "success")
    @alert = alert
    @kind = kind
  end
end