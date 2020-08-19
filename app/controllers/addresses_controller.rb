class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]


  # GET /addresses
  # GET /addresses.json
  def index
    @addresses = current_user.addresses
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new
    @map = true
  end

  # GET /addresses/1/edit
  def edit
    @map = true
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @address = Address.new(address_params)
    if user_signed_in?
      if params["address"]["model"] === "User"
        @address.model = current_user
        # Debemos actualizar las otras direcciones de entrega
      else
        model = params["address"]["model"].constantize
        @address.model = model.find_by(id: params["address"]["model_id"])
      end
    else
      @address.model = @current_cart
    end

    respond_to do |format|
      # format.json { render json: @address.errors, status: :unprocessable_entity } if poly_model.nil?
      if @address.save
        if params["address"]["current"]
          puts "-----------------#{params["address"]["current"]}----------AGREGANDO-------#{@address.attributes}"
          #Se agrega este address a la sesión
          session[:current_address] = @address
          session[:demo] = "POPODEPERRO"
          @current_address = @address
        end
        format.html { redirect_to @address, notice: 'Address was successfully created.' }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_address
    @address = current_user.addresses.find(params[:id])
    not_found if @address.nil?
  end

  # Only allow a list of trusted parameters through.
  def address_params
    params.require(:address).permit(:address, :city, :country, :default, :internal_number, :description, :current, :lat, :lng)
  end
end
