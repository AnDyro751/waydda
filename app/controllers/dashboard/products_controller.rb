class Dashboard::ProductsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_item, only: [:create]
  before_action :set_product, only: [:show, :edit, :update, :update_status, :destroy]
  add_breadcrumb "Inicio", :my_place_path
  add_breadcrumb "Productos", :dashboard_products_path

  def index
    @products = @place.products.paginate(page: params[:page], per_page: 20)
  end


  def show
    add_breadcrumb "#{@product.name}", :dashboard_product_path
  end

  def new
    add_breadcrumb "Nuevo producto"
    @product = Product.new
    @product.aggregate_categories.build
    @product.aggregate_categories.new.aggregates.new
  end

  def edit
    add_breadcrumb "#{@product.name}", :dashboard_product_path
    add_breadcrumb "Editar"
  end

  def create
    @product = Product.new(product_params)
    @product.place = @place

    respond_to do |format|
      if @product.save
        if params["product"]["item_ids"].present?
          Product.update_recent_products(item_ids: params["product"]["item_ids"], product: @product, action: "create")
        end
        format.html { redirect_to dashboard_product_path(@product.slug), alert: 'Se ha creado el producto' }
      else
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      old_items = @product.item_ids.map(&:to_s)
      new_items = params["product"]["item_ids"].select { |ii| ii.length > 0 }
      old_items.each do |ii|
        new_items.delete(ii)
      end
      params["product"]["item_ids"].each do |ii|
        old_items.delete(ii)
      end
      if @product.update(product_params)
        if new_items.length > 0 # Se agregaron nuevos elementos
          Product.update_recent_products(item_ids: new_items, product: @product, action: "create")
        end
        if old_items.length > 0 # Se eliminaron elementos - Eliminar de los recientes del item
          Product.update_recent_products(item_ids: old_items, product: @product, action: "delete")
        end
        # format.html { redirect_to dashboard_product_path(@product.slug), alert: 'Se ha actualizado el producto.' }
        format.js
        # format.json { render :show, status: :ok, location: @product.slug }
      else
        format.js
        # format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_status
    respond_to do |format|
      begin
        if params["to_status"] === "activate"
          @product.activate!
        elsif params["to_status"] === "deactivate"
          @product.deactivate!
        else
          format.html { redirect_to edit_dashboard_product_path(@product.slug), notice: "Ha ocurrido un error al actualizar el producto" }
        end
        format.html { redirect_to edit_dashboard_product_path(@product.slug), alert: "Se ha actualizado el producto" }
      rescue => e
        puts "-----#{e}"
        format.html { redirect_to edit_dashboard_product_path(@product.slug), notice: "Ha ocurrido un error al actualizar el producto" }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_products_path, alert: 'Producto eliminado correctamente' }
      format.json { head :no_content }
    end
  end


  private

  def set_item
    if params["product"]["item_id"].present?
      @item = Item.find_by(place: @place, id: params["product"]["item_id"])
      not_found if @item.nil?
    end
  end

  def set_product
    @product = Product.find_by(slug: params["id"] || params["product_id"])
    not_found if @product.nil?
  end


  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :description, :price, :aggregates_required, :max_aggregates, :public_stock, :unlimited, :quantity, :quantity_measure, item_ids: [], aggregate_categories_attributes: [])
  end
end
