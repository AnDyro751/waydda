class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  after_action :update_view, only: [:show]

  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  # GET /places/1.json
  def show
    respond_to do |format|
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

  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:name, :address, :slug, :user_id, :status)
  end
end
