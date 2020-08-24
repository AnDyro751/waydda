class PlacesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :catalog]
  before_action :set_place, only: [:show, :edit, :update, :destroy, :catalog]
  before_action :validate_my_identity, except: [:show, :new, :index, :catalog]
  after_action :update_views, only: [:show]

  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  def catalog

  end

  # GET /places/1
  # GET /places/1.json
  def show
    @products = @place.products.paginate(page: params[:page], per_page: 30)
    @delivery_option = @current_cart.delivery_options.find_by(place: @place)
  end

  private

  def update_views
    # TODO: Add counter
    # code here
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = Place.find_by(slug: params[:id] || params["place_id"])
    not_found if @place.nil?
    if current_user
      unless current_user.id == @place.user_id
        not_found if !@place.active?
      end
    else
      not_found if !@place.active?
    end
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
