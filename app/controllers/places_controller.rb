class PlacesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_place, only: [:show, :edit, :update, :destroy,:my_place]
  before_action :validate_my_identity, except: [:show, :new, :index]
  before_action :set_my_place, only: [:my_place]
  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  def my_place
  end

  # GET /places/1
  # GET /places/1.json
  def show
  end

  private



  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = Place.find(params[:id])
    not_found if @place.nil?
  end

  def validate_my_identity
    unless @place.user === current_user
      flash[:alert] = "No puedes acceder a este recurso"
      redirect_to root_path #,status: :unprocessable_entity
    end
  end


  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:name, :address, :slug, :user_id, :status)
  end
end
