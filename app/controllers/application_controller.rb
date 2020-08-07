class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_my_place
    @place = current_user.places.first
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:lastName])
  end
end
