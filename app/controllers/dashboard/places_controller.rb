class Dashboard::PlacesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_my_place, only: [:my_place]
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
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
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
    end


  # Only allow a list of trusted parameters through.
    def place_params
      params.require(:place).permit(:name, :address, :slug, :user_id, :status)
    end
end
