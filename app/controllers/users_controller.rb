class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_profile
    @new_address = current_or_guest_user.current_address || current_or_guest_user.addresses.new
    respond_to do |format|
      format.html
      format.js
    end
  end


  def update
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to my_profile_path, notice: 'Se ha actualizado tu perfil' }
        # format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit, alert: "Ha ocurrido un error" }
        # format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    @user = current_user
    respond_to do |format|
      if @user.update(user_params)
        # Sign in the user by passing validation in case their password changed
        bypass_sign_in(current_user)
        format.html { redirect_to root_path, notice: "Contraseña actualizada" }
      else
        puts "#{@user.errors.full_messages}"
        format.html { render :edit, alert: "Ha ocurrido un error" }
      end
    end
  end

  def destroy
  end

  def edit
  end


  private

  def user_params
    # TODO: Validar email
    params.require(:user).permit(:name, :lastName, :email, :password, :password_confirmation)
  end

end
