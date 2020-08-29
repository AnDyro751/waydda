class Dashboard::PlacesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place, except: [:new, :create] #, except: [:new, :create]
  before_action :valid_uniqueness_place, only: [:new, :create]
  before_action :redirect_if_empty_place, only: [:my_place, :edit, :update, :destroy]

  def new
    @place = Place.new
  end

  def sales
  end

  def my_place
    if @place.nil?
      redirect_to new_dashboard_place_path
    end
    @products = @place.products.where(:last_viewed.gte => (Date.today - 30)).paginate(page: params[:page], per_page: 20)
    @orders = Order.where(place: @place, status: "pending")
  end

  # GET /places/1/edit
  def edit
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json


  def create
    @place = Place.new(place_params)
    @place.user = current_user
    respond_to do |format|
      if @place.save
        format.html { redirect_to my_place_path, notice: 'Place was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end


  def update
    if params["to_action"]
      update_status params["to_action"], @place
    else
      respond_to do |format|
        if @place.update(place_params)
          format.js
          format.html { redirect_to my_place_path, notice: 'Place was successfully updated.' }
          format.json { render 'dashboard/places/show', status: :ok, location: my_place_path(@place) }
        else
          format.js
          format.html { render :edit }
          format.json { render json: @place.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # post /update_slug
  def update_slug
    respond_to do |format|
      format.html { redirect_to my_place_path, notice: 'Place was successfully updated.' } if params["place"]["slug"] == @place.slug
      other_place = Place.find_by(slug: params["place"]["slug"].parameterize)
      format.html { redirect_to my_place_path, alert: 'Este nombre de usuario no está disponible' } unless other_place.nil?
      if @place.update(slug: params["place"]["slug"].parameterize)
        format.html { redirect_to my_place_path, notice: 'Nombre de usuario actualizado correctamente' }
      else
        format.html { redirect_to my_place_path, alert: 'Ha ocurrido un error al actualizar el lugar' }
      end
    end
  end

  def update_status(action, place)
    # TODO: Add edit.html
    # TODO: Remote true functionality - loading button
    respond_to do |format|
      begin
        place.activate! if action == "activate"
        place.deactivate! if action == "deactivate"
        format.html { redirect_to my_place_path, notice: action === "activate" ? "Se ha activado tu empresa" : "Se ha descativado tu empresa" }
      rescue => e
        format.html { redirect_to my_place_path, alert: "Ha ocurrido un error, intenta de nuevo" }
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
    if @place.nil?
      redirect_to new_dashboard_place_path
    end
  end

  def valid_uniqueness_place
    unless @place.nil?
      flash[:alert] = "Por el momento sólo puedes crear una empresa"
      redirect_to my_place_path
    end
  end


  def redirect_if_empty_place
    if @place.nil?
      flash[:notice] = "Crea un negocio"
      redirect_to new_dashboard_place_path
    end
  end


  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:name, :address, :slug, :user_id, :status, :delivery_option, :delivery_cost, :delivery_extra_cost, :delivery_distance, location: [:lat, :lng])
  end
end
