class Dashboard::ProductsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_item, only: [:create]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /places
  # GET /places.json
  def index
    @products = @place.products.paginate(page: params[:page], per_page: 20)
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
        format.html { redirect_to dashboard_product_path(@product.slug), notice: 'Place was successfully created.' }
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
      if @product.update(product_params)
        format.html { redirect_to dashboard_product_path(@product.slug), notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @product.slug }
      else
        puts "#{@product.errors.full_messages}-----"
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_products_path, notice: 'Producto eliminado correctamente' }
      format.json { head :no_content }
    end
  end


  private

  def set_item
    @item = Item.find_by(place: @place, id: params["product"]["item_id"])
    not_found if @item.nil?
  end

  def set_product
    @product = Product.find_by(slug: params["id"])
    not_found if @product.nil?
  end


  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :description, :price, :aggregates_required, :max_aggregates, :item_id, :public_stock)
  end
end
