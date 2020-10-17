class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :current_cart
  before_action :current_or_guest_user
  before_action :set_current_address
  before_action :set_time_zone
  before_action :set_language
  before_action :set_continue
  before_action :set_raven_context
  protect_from_forgery
  # before_action :set_default_locations


  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id.to_s
        # logging_in(guest_user, current_user)
        # reload guest_user to prevent caching problems before  destruction
        guest_user(with_retry = false).try(:reload).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      puts "-----------ELSE"
      guest_user
    end
  end

  helper_method :current_or_guest_user


  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id])
    puts "------------#{@cached_guest_user} 1"
    if @cached_guest_user.nil?
      @cached_guest_user = create_guest_user
      puts "------------#{@cached_guest_user} ---2"
    end

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
  end


  def create_guest_user
    u = User.new
    u.save(validate: false)
    puts "-------------_#{u.persisted?} 3"
    puts "------------#{u.id.to_s} ---4"
    session[:guest_user_id] = u.id.to_s
    u
  end

  helper_method :create_guest_user


  def add_log(message)
    puts "Logger info: ----- #{message}"
  end

  def set_continue
    if params[:continue]
      session[:continue] = params[:continue]
    end
  end

  def after_sign_in_path_for(resource)
    # puts "-------------SIGN IN PATH FOR"
    # current_or_guest_user
    MergeUserCartsJob.perform_later(guest_user, current_user)
    session[:guest_user_id] = nil
    if session[:continue]
      navigation = session[:continue]
      session[:continue] = nil
      navigation
    else
      current_return_to = session["user_return_to"]
      session["user_return_to"] = nil
      current_return_to || root_path
    end
  end


  def set_price
    @premium_pricing = 229
    @free_days = 14
  end

  def set_language
    response.headers["Content-Language"] = "es"
  end

  def set_my_place
    @place = current_user.places.first
    puts "------#{current_user}------!!#{@place}!! SET MY PLACE"
    if @place.nil?
      redirect_to new_dashboard_place_path, notice: "Crea una empresa para continuar"
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

  def hook_controller
    controller_name == "hooks"
  end


  def set_raven_context
    puts "--------------------------------------#{session[:guest_user_id]}"
    Raven.user_context(id: session[:guest_user_id]) # or anything else in session
  end

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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :lastName, :timezone, :pricing_selected])
  end

end
