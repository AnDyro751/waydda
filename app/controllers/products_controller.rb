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
    # TODO: Add 404 page
    #render :file => "#{RAILS_ROOT}/public/404.html",  :status => 404
    raise ActiveRecord::RecordNotFound if @place.nil?
  end

  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:name, :address, :slug, :user_id, :status)
  end
end
