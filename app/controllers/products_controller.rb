class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  # GET /places/1.json
  def show
  end

  private


  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = Place.find(params[:id])
    not_found if @place.nil?
  end

  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:name, :address, :slug, :user_id, :status)
  end
end
