class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :current_cart
  before_action :set_current_address
  before_action :set_time_zone
  # before_action :set_default_locations


  def set_my_place
    @place = current_user.places.first
    if @place.nil?
      redirect_to new_dashboard_place_path
    end
  end

  def default_locations
    [
        {key: "Atizapán de Zaragosa", value: "atizapan-de-zaragoza"},
        {key: "Atlacomulco", value: "atlacomulco"},
        {key: "Ecatepec", value: "ecatepec"},
        {key: "Naucalpan", value: "naucalpan"},
        {key: "Nezahualcóyotl", value: "nezahualcoyotl"},
        {key: "Tenango", value: "tenango"},
        {key: "Texcoco", value: "texcoco"},
        {key: "Toluca", value: "toluca"},
        {key: "Valle de Bravo", value: "valle-de-bravo"},
    ]
  end

  helper_method :default_locations


  def browser_time_zone
    browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies[:timezone])
    ActiveSupport::TimeZone.all.find { |zone| zone.tzinfo == browser_tz } || ActiveSupport::TimeZone.find_tzinfo("America/Mexico_City")
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    ActiveSupport::TimeZone.find_tzinfo("America/Mexico_City")
  end

  helper_method :browser_time_zone

  def set_time_zone
    if user_signed_in?
      Time.zone = current_user.timezone
    else
      Time.zone = browser_time_zone
    end
  end


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def set_current_address
    if user_signed_in?
      @current_address = current_user.current_address
      session[:current_address] = @current_address || nil
    else
      if session[:current_address]
        @current_address = Address.find_by(id: session[:current_address].id.to_s)
        session[:current_address] = @current_address
      else
        session[:current_address] = nil
      end
    end

  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :lastName, :timezone])
  end

end
