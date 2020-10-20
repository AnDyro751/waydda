class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_place, only: [:show, :index]
  before_action :set_current_cart, only: [:show, :index]
  before_action :set_available_distance, only: [:index, :show]

  # GET /items
  # GET /items.json
  def index
    set_meta_tags title: "Departamentos | #{@place.name}",
                  description: "Departamentos | #{@place.name}"
    @items = @place.items.includes(:recent_products).select { |item| item.recent_products.length > 0 }
  end

  # GET /items/1
  # GET /items/1.json
  def show
    set_meta_tags title: "#{@item.name} | Departamentos #{@place.name}",
                  description: "#{@item.name} | Departamentos #{@place.name}"
    @products = @place.products.where(:item_ids.in => [@item.id]).paginate(page: params[:page], per_page: 30)
  end

  private

  def set_place
    @place = Place.find_by(slug: params["place_id"])
    not_found if @place.nil?
    if current_user
      unless current_user.id == @place.user_id
        not_found if @place.pending?
      end
    else
      not_found if @place.pending?
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end


  def set_current_cart
    @current_cart = current_or_guest_user.carts.find_or_create_by(place: @place, status: "pending", delivery_kind: "pickup")
    if @current_cart
      @delivery_option = @current_cart.delivery_option
    end
  end

  def set_available_distance
    @available_distance = @place.available_distance?(current_or_guest_user.get_ll)
  end


  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :place_id)
  end
end
