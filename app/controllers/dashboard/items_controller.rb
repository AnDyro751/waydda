class Dashboard::ItemsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy, :remove_product]
  before_action :set_my_place
  before_action :set_product, only: [:remove_product]
  add_breadcrumb "Departamentos", :dashboard_items_path

  # GET /items
  # GET /items.json
  def index
    set_meta_tags title: "Departamentos | Panel de control",
                  description: "Departamentos | Panel de control"
    @items = @place.items.paginate(page: params[:page], per_page: 25)
  end

  # GET /items/1
  # GET /items/1.json
  def show
    add_breadcrumb "#{@item.name}"
    set_meta_tags title: "#{@item.name} - Departamento | Panel de control",
                  description: "#{@item.name} - Departamento | Panel de control"
    @products = @item.products.paginate(page: params[:page], per_page: 20)
  end

  # GET /items/new
  def new
    @custom_type = params["custom_type"].present?
    add_breadcrumb "Nuevo departamento"
    set_meta_tags title: "Nuevo departamento | Panel de control",
                  description: "Nuevo departamento | Panel de control"
    @item = @place.items.new
  end

  # GET /items/1/edit
  def edit
    add_breadcrumb "#{@item.name}", dashboard_item_path(@item)
    add_breadcrumb "Editar"
    set_meta_tags title: "Editar #{@item.name} - Departamento | Panel de control",
                  description: "Editar #{@item.name} - Departamento | Panel de control"
  end

  # POST /items
  # POST /items.json
  def create
    @item = @place.items.new(item_params)
    respond_to do |format|
      if @item.save
        @items = @place.items
        format.js if params["type"]
        format.html { redirect_to dashboard_items_path, alert: 'Se ha creado el departamento' }
        format.json { render :show, status: :created, location: @item }
      else
        format.js if params["type"]
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
        format.html { redirect_to dashboard_item_path(@item), alert: 'Se ha actualizado el departamento' }
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
      format.html { redirect_to dashboard_items_path, alert: 'Se ha eliminado el departamento' }
      format.json { head :no_content }
    end
  end

  # DELETE /items/1/:product_id
  def remove_product
    # Vamos a eliminar de los recientes y de los items
    respond_to do |format|
      begin
        @item.products.delete(@product)
        @item.recent_products.delete(@product)
      rescue => e
        format.html { redirect_to dashboard_items_path, notice: "Ha ocurrido un error al actualizar el departamento" }
      end
      format.js
    end
  end


  private

  def set_product
    @product = @place.products.find(params["product_id"])
    if @product.nil?
      not_found
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find_by(id: params[:id] || params[:item_id]) || not_found
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :description)
  end
end
