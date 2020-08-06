class Dashboard::PlacesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!, except: [:show]
  before_action :set_my_place, only: [:my_place,:update]
  # GET /places
  # GET /places.json

  def my_place
  end

  # GET /places/1/edit
  def edit
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    if params["to_action"]
      update_status params["to_action"], @place
    else
      respond_to do |format|
        if @place.update(place_params)
          format.html { redirect_to my_place_path, notice: 'Place was successfully updated.' }
          format.json { render :show, status: :ok, location: @place }
        else
          format.html { render :edit }
          format.json { render json: @place.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update_status(action, place)
    # TODO: Add edit.html
    # TODO: Remote true functionality - loading button
    respond_to do |format|
      begin
        place.activate! if action == "activate"
        place.deactivate! if action == "deactivate"
        format.html { redirect_to my_place_path, notice: action === "activate" ? "Se ha activado tu empresa" : "Se ha descativado tu empresa" }
      rescue => e
        format.html { redirect_to my_place_path, alert: "Ha ocurrido un error, intenta de nuevo" }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  def set_my_place
    @place = current_user.places.first
    if @place.nil?
      flash[:notice] = "Crea un negocio"
      redirect_to new_dashboard_place_path
    end
  end


  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:name, :address, :slug, :user_id, :status)
  end
end
