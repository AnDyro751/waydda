class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      remember_me(@user)
      if @current_cart
        # Merge items
        user_cart = @user.cart
        if user_cart
          # TODO: Hacer refactor de este código, mandarlo en un job o en un callback y poner lo mismo a google y al login normal
          items = @current_cart.cart_items.where(added_in: false).includes(:model)
          session[:cart_id] = user_cart.id.to_s
          @current_cart = user_cart
          items.each do |item|
            item.update(added_in: true)
            @current_cart.update_item(item.model.id, 1, true, true)
          end
        else
          @current_cart.update(user: @user)
        end
      end
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      puts "#{@user.errors.full_messages}"
      flash[:notice] = @user.errors.full_messages.join(", ")
      redirect_to new_user_registration_url
    end
  end


  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      if @current_cart
        @current_cart.update(user: @user)
      end
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
      flash[:notice] = @user.errors.full_messages.join(", ")
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
