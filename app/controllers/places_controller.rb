class PlacesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :catalog, :index]
  before_action :set_place, only: [:show, :edit, :update, :destroy, :catalog]
  before_action :validate_my_identity, except: [:show, :new, :index, :catalog]
  after_action :update_views, only: [:show]
  before_action :set_current_cart, only: [:show, :catalog]
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
  end



  private


  def update_views
    # TODO: Add counter
    # code here
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = Place.find_by(slug: params[:id] || params["place_id"])
    # TODO: Agregar delivery option y current cart
    not_found if @place.nil?
    if current_user
      unless current_user.id == @place.user_id
        not_found if @place.pending?
      end
    else
      not_found if @place.pending?
    end
  end

  def set_current_cart
    @current_cart = current_user.carts.find_or_create_by(place: @place, status: "pending")
    if @current_cart
      @delivery_option = @current_cart.delivery_option
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
