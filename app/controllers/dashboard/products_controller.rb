class Dashboard::ProductsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_item, only: [:create]
  before_action :set_product, only: [:show]
  # GET /places
  # GET /places.json
  def index
    @products = @place.products
  end


  # GET /places/1
  # GET /places/1.json
  def show
  end

  # GET /places/new
  def new
    @product = @place.products.new
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places
  # POST /places.json
  def create
    @product = Product.new(product_params)
    @product.item = @item
    @product.place = @place
    respond_to do |format|
      if @product.save
        format.html { redirect_to dashboard_product_path(@product), notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
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

  def set_item
    @item = Item.find_by(place: @place,id: params["product"]["item_id"])
    raise ActiveRecord::RecordNotFound if @item.nil?
  end

  def set_product
    @product = Product.find(params["id"])
    raise ActiveRecord::RecordNotFound if @product.nil? || @product.place_id != @place.id
  end
  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :description, :price, :aggregates_required, :max_aggregates, :photo,:item_id)
  end
end
