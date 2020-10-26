class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  after_action :update_view, only: [:show]
  before_action :set_current_cart, only: [:show]
  before_action :set_distance, only: [:show]
  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  # GET /places/1
  def show
    set_meta_tags title: "#{@product.name} en Waydda",
                  description: "Compra #{@product.name} y cientos de productos más en Waydda."
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_product
    @product = @place.products.find_by(slug: params["id"])
    if @product.nil?
      not_found
    end
  end

  def update_view
    UpdateViewCounterJob.perform_later(@product)
    # code here
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = Place.find_by(slug: params[:place_id])
    not_found if @place.nil?
  end

  def set_distance
    @available_distance = @place.available_distance?(current_or_guest_user.get_ll)
  end

  def set_current_cart
    @current_cart = current_or_guest_user.carts.find_or_create_by(place: @place, status: "pending", delivery_kind: "pickup")
    if @current_cart
      @delivery_option = @current_cart.delivery_option
    end
  end


  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:name, :address, :slug, :user_id, :status)
  end
end
