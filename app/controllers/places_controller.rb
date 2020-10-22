class PlacesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :catalog, :index]
  before_action :set_place, only: [:show, :edit, :update, :destroy, :catalog]
  before_action :validate_my_identity, except: [:show, :new, :index, :catalog]
  before_action :set_current_cart, only: [:show, :catalog]
  before_action :set_line_items, only: [:show]
  after_action :update_views, only: [:show]

  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  def catalog
    @available_distance = @place.available_distance?(current_or_guest_user.get_ll)
    @items = @place.items.includes(:recent_products).select { |item| item.recent_products.length > 0 }
  end

  # GET /places/1
  # GET /places/1.json
  def show
    set_meta_tags title: "#{@place.name} en Waydda",
                  description: "Visita la tienda en línea de #{@place.name} en Waydda"
    @available_distance = @place.available_distance?(current_or_guest_user.get_ll)
    # @place.products.paginate(page: params[:page], per_page: 30)
    @items = @place.items.includes(:recent_products).paginate(page: params[:page], per_page: 30)
    @item_arrays = @items.select { |item| item.recent_products.length > 0 }
    # @products = @place.products.where(:items_recents.with_size => 0, status: "active")
    @products = []
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
        not_found if @place.pending?
      end
    else
      not_found if @place.pending?
    end
  end

  def set_current_cart
    @current_cart = current_or_guest_user.carts.find_or_create_by(place: @place, status: "pending", delivery_kind: "pickup")
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


  def set_line_items
    @cart_items = @current_cart.cart_items.includes(:product).select { |ci| ci.product.status === "active" } # Mostramos los productos del carrito que aún estén activos
  end


  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:name, :address, :slug)
  end
end
