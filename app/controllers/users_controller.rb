class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_profile
    @current_address = current_user.addresses.select { |address| address.default }.first
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

  def destroy
  end

  def edit
  end


  private

  def user_params
    # TODO: Validar email
    params.require(:user).permit(:name, :lastName, :email)
  end

end
