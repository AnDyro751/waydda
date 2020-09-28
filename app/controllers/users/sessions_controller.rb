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
    respond_to do |format|
      if params["user"]["phone"].present?
        @user = User.find_by(phone: "#{params["user"]["phone"]}")

        if @user.nil?
          puts "------------USER ES NIL"
          @user = User.new(phone: "#{params["user"]["phone"]}")
          puts "---------#{@user.errors.full_messages}"
          @user.save
        else
          unless params["user"]["verification_code"].present?
            @user.create_and_send_verification_code
          end
        end
        if params["user"]["verification_code"].present?
          @last_verification_code = @user.phone_codes.order(created_at: "desc").limit(1).to_a.first
          puts "NO HAY CPODIGO DE VERIFICACIONE" if @last_verification_code.nil?
          if params["user"]["verification_code"] === @last_verification_code.verification_code
            puts "-------DICE QUE NO"
            # sign_in @user
            format.html { sign_in_and_redirect @user, notice: "Bienvenido de nuevo" }
            # format.html { redirect_to root_path, alert: "Bienvenido de nuevo" }
          else
            puts "-------DICE QUE NO 2"
            format.html { redirect_to new_user_session_path, notice: "El código de verificación es incorrecto" }
          end
        else
          format.js
        end
      else
        format.html { redirect_to new_user_session_path, notice: "Ingresa un número de teléfono" }
      end
    end
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
