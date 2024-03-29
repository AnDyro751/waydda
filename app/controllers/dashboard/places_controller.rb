class Dashboard::PlacesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place, except: [:new, :create, :get_distance_from_current_user] #, except: [:new, :create]
  before_action :valid_uniqueness_place, only: [:new, :create]
  before_action :redirect_if_empty_place, only: [:my_place, :edit, :update, :destroy]
  before_action :set_user_account, only: [:connect, :create_account_link, :create_stripe_account]
  before_action :set_price, only: [:upgrade]

  Stripe.api_key = 'sk_test_51H9CZeBOcPJ0nbHctTzfQZhFXBnn8j05e0xqJ5RSVz5Bum72LsvmQKIecJnsoHISEg0jUWtKjERYGeCAEWiIAujP00Fae9MiKm'

  def new
    set_meta_tags title: "Crear empresa | Panel de control",
                  description: "Crear empresa | Panel de control"
    @place = current_user.places.first
    if @place.nil?
      @place = Place.new
    else
      redirect_to my_place_path, notice: "Solo puedes crear una empresa"
    end
  end

  def sales
  end


  def upgrade
    set_meta_tags title: "Suscripción | Waydda",
                  description: "Suscripción | Waydda"
    @full_page = true
  end

  def connect
    set_meta_tags title: "Pagos con tarjeta - Ajustes | Panel de control",
                  description: "Pagos con tarjeta - Ajustes | Panel de control"
    add_breadcrumb "Ajustes", dashboard_edit_my_place_path
    add_breadcrumb "Pagos con tarjeta"
  end

  def create_account_link
    redirect_to dashboard_place_connect_path, notice: "Primero conecta tu cuenta bancaria" if @user_account.nil?
    @account_link = Account.create_link(@user_account.account_id, !@user_account.details_submitted)

    respond_to do |format|
      if @account_link.nil?
        format.html { redirect_to dashboard_place_connect_path, notice: "Ha ocurrido un error al redirigir a tu panel de control", status: :unprocessable_entity }
        format.json { render json: {errors: "Ha ocurrido un error al redirigir a tu panel de control"}, status: :unprocessable_entity }
      else
        format.json { render json: {link: @account_link["url"]}, status: :created }
        format.js
      end
    end
  end

  def create_stripe_account
    respond_to do |format|
      # @connect = Place.create_stripe_account_link(current_user)
      @connect = Account.create_link(@user_account.account_id, @user_account.details_submitted)
      if @connect.nil?
        format.html { redirect_to dashboard_place_connect_path, notice: "Ha ocurrido un error al generar la configuración 2" }
      else
        format.js
      end
    end
  end


  def my_place
    set_meta_tags title: "#{@place.name} | Panel de control",
                  description: "#{@place.name} | Panel de control"
    @products = @place.products.where(:last_viewed.gte => (Date.today - 30)).paginate(page: params[:page], per_page: 20)
    @orders = Order.where(place: @place, status: "pending")
  end

  # GET /dashboard/settings
  def edit
    set_meta_tags title: "Ajustes de mi empresa | Panel de control",
                  description: "Ajustes de mi empresa | Panel de control"
    add_breadcrumb "Ajustes"
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json


  def create
    @place = current_user.places.first
    redirect_to my_place_path, notice: "Solo puedes crear una empresa" unless @place.nil?
    @place = Place.new(place_general_params)
    @place.user = current_user
    respond_to do |format|
      if @place.save
        # format.js
        format.html { redirect_to my_place_path, alert: 'Se ha creado tu empresa' }
      else
        format.js
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  # TODO: Update status

  def update
    # puts "--------#{@place.item_ids_changed?}"

    if params["to_action"]
      update_status params["to_action"], @place
    else
      respond_to do |format|
        if can? :update, @place
          if @place.update(place_general_params)
            format.js
            format.html { redirect_to my_place_path, notice: 'Place was successfully updated.' }
            format.json { render 'dashboard/places/show', status: :ok, location: my_place_path(@place) }
          else
            format.js
            format.html { render :edit }
            format.json { render json: @place.errors, status: :unprocessable_entity }
          end
        else
          format.html { redirect_to dashboard_edit_my_place_path, notice: "No tienes los permisos necesarios para realizar esta acción", status: :unprocessable_entity }
        end
      end
    end
  end

  def update_delivery
    respond_to do |format|
      # puts "-------#{can?(:update, @place) and @place.premium?}"
      if can?(:update, @place) and @place.kind === "premium"
        if @place.update(place_delivery_params)
          format.js
        else
          format.js
        end
      else
        if @place.kind == "free"
          format.html { redirect_to dashboard_edit_my_place_path, notice: "Actuaiza tu plan para acceder ofrecer envíos a domicilio" }
        else
          format.html { redirect_to dashboard_edit_my_place_path, notice: "No tienes los permisos necesarios para realizar está acción" }
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
        place.update(status: "active") if action == "activate"
        place.update(status: "inactive") if action == "deactivate"
        format.html { redirect_to my_place_path, alert: action === "activate" ? "Se ha activado tu empresa" : "Se ha descativado tu empresa" }
      rescue => e
        puts "--------#{e}"
        format.html { redirect_to dashboard_edit_my_place_path, notice: "#{e}" }
      end
    end
  end

  def get_distance_from_current_user
    if current_or_guest_user.current_address
      render json: {errors: nil, distance: @place.get_distance([current_user.current_address.lat, current_user.current_address.lng])}
    else
      render json: {errors: "Agrega una dirección de entrega", distance: 0}
    end
    # return json {errors: ""}
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      sign_out(current_user)
      format.html { redirect_to root_path, notice: 'Se ha eliminado tu empresa' }
      format.json { head :no_content }
    end
  end


  private


  def set_user_account
    @user_account = current_user.account
    if @user_account.nil?
      @user_account = Account.create_stripe_account(@place, current_user)
      puts "----------USER ACCOUNT ES NULo---------#{@user_account}"

    end
  end


  def valid_uniqueness_place
    unless @place.nil?
      flash[:notice] = "Por el momento sólo puedes crear una empresa"
      redirect_to my_place_path
    end
  end


  def redirect_if_empty_place
    if @place.nil?
      redirect_to new_dashboard_place_path, alert: "Crea una empresa para continuar"
    end
  end


  def place_general_params
    params.require(:place).permit(:name, :address, :photo, :cover, :lat, :lng, :external_number, :category)
  end

  def place_delivery_params
    params.require(:place).permit(:delivery_option, :delivery_cost, :delivery_distance, :pickup_time)
  end
end
