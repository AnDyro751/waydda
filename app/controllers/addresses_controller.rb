class AddressesController < ApplicationController

  before_action :authenticate_user!, only: [:index]
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :set_page_type, only: [:update, :create]
  # before_action :set_place, only: [:update, :create]

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
    @address.current = true
    if user_signed_in?
      @address.model = current_user
    else
      @address.model = @current_cart
    end

    respond_to do |format|
      if @address.save
        session[:current_address] = @address
        @current_address = @address
        format.html { redirect_to my_profile_path, notice: 'Se ha registrado la dirección de entrega' }
        format.js {}
      else
        puts "--------#{@address.errors.map { |e, k| puts "-----#{e}------#{k}" }}"
        format.js {}
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        # format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.js
        # format.json { render :show, status: :ok, location: @address }
      else
        format.js
        # format.html { render :edit }
        # format.json { render json: @address.errors, status: :unprocessable_entity }
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

  def set_page_type
    @page_type = params["address"]["page_type"]
  end

  # Only allow a list of trusted parameters through.
  def address_params
    params.require(:address).permit(:address, :city, :country, :default, :internal_number, :description, :current, :lat, :lng, :instructions)
  end
end
