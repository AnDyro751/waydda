class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_cart

  def set_my_place
    @place = current_user.places.first
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :lastName])
  end

  def current_cart
    if user_signed_in?
      session[:cart_id] = current_user.cart.id
      if session[:cart_id].nil?
        cart = current_user.create_cart
        session[:cart_id] = cart.id
        @current_cart = Cart.find(cart.id)
      else
        @current_cart = Cart.find(session[:cart_id])
      end
    else
      if session[:cart_id]
        @current_cart = Cart.find(session[:cart_id])
      else
        cart = Cart.new(quantity: 0)
        if cart.save
          session[:cart_id] = cart.id
          @current_cart = Cart.find(session[:cart_id])
        end
      end
    end
  end


end
