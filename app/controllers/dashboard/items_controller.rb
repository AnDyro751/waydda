class Dashboard::ItemsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_my_place

  # GET /items
  # GET /items.json
  def index
    @items = @place.items.paginate(page: params[:page], per_page: 25)
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @products = @item.products.paginate(page: params[:page], per_page: 20)
  end

  # GET /items/new
  def new
    @item = @place.items.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = @place.items.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to dashboard_items_path, alert: 'Se ha creado el item' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to dashboard_item_path(@item), alert: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_items_path, alert: 'Se ha eliminado la categoría' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :description)
  end
end
