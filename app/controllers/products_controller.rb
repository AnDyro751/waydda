class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :validate_my_identity, except: [:show,:new,:index,:my_business]
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

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)
    @place.user = current_user
    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
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

  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = Place.find(params[:id])
    # TODO: Add 404 page
    #render :file => "#{RAILS_ROOT}/public/404.html",  :status => 404
    raise ActiveRecord::RecordNotFound if @place.nil?
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
