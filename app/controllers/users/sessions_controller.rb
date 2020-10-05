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
        unless Phonelib.valid?("+52#{params["user"]["phone"]}")
          @error = "Número de teléfono incorrecto"
          return format.js
        end
        @user = User.find_by(phone: "#{params["user"]["phone"]}")

        if @user.nil?
          puts "------------USER ES NIL"
          @user = User.new(phone: "#{params["user"]["phone"]}")
          # puts "---------#{@user.errors.full_messages}"
          @user.save
        else
          unless params["user"]["verification_code"].present?
            begin
              puts "ENVIANDO 1"
              @user.create_and_send_verification_code
              @show_input = true
            rescue => e
              puts "------------!!--#{e}"
              @error = e
              @show_input = true
              return format.js
              return false
            end
          end
        end
        if params["user"]["verification_code"].present?
          @last_verification_code = @user.get_last_phone_code
          puts "NO HAY CPODIGO DE VERIFICACIONE" if @last_verification_code.nil?
          if @last_verification_code.nil?
            puts "ENVIANDO 3"
            @last_verification_code = @user.create_and_send_verification_code
          end
          if params["user"]["verification_code"] === @last_verification_code.verification_code
            @last_verification_code.update(status: "used")
            format.html { sign_in_and_redirect @user, notice: "Bienvenido de nuevo" }

          else
            @error = "El código de verificación es incorrecto"
            format.js
          end
        else
          format.js
        end
      else
        @error = "Ingresa un número de teléfono"
        format.js
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
