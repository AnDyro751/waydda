class Dashboard::Header::Simple < ViewComponent::Base
  # @return [Simple] Component
  def initialize(place:, current_user:)
    @place = place
    @current_user = current_user
  end
end