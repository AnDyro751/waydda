# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :set_price
  layout "sessions"
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    redirect_to new_user_session_path, notice: "Ingresa un número de teléfono" unless params["user"]["phone"].present?
    @user = User.find_by(phone: "+52#{params["user"]["phone"]}")
    if @user.nil?
      puts "------------USER ES NIL"
      @user = User.new(phone: "+52#{params["user"]["phone"]}")
      puts "---------#{@user.errors.full_messages}"
      @user.save
    end
    sign_in_and_redirect @user, :event => :authentication

    # super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:phone])
  end
end
