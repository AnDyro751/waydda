class Dashboard::ProductsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_product, only: [:show, :edit, :update, :update_status, :destroy, :edit_inventory, :edit_variants]
  add_breadcrumb "Productos", :dashboard_products_path


  def index
    set_meta_tags title: "Productos | Panel de control",
                  description: "Productos - Panel de control"
    @products = @place.products.paginate(page: params[:page], per_page: 20)
  end


  def show
    set_meta_tags title: "#{@product.name} | Panel de control",
                  description: "#{@product.name} - Panel de control"
    add_breadcrumb "#{@product.name}", :dashboard_product_path

  end

  def new
    add_breadcrumb "Nuevo producto"
    @product = Product.new
    @product.aggregate_categories.build
    @product.aggregate_categories.new.aggregates.new
  end

  def edit
    set_meta_tags title: "Editar #{@product.name} | Panel de control",
                  description: "Editar #{@product.name} | Panel de control"
    add_breadcrumb "#{@product.name}", :dashboard_product_path
    add_breadcrumb "Editar"
  end

  # GET /edit/inventory
  def edit_inventory
    set_meta_tags title: "Editar inventario de #{@product.name} | Panel de control",
                  description: "Editar inventario de #{@product.name} | Panel de control"
    add_breadcrumb "#{@product.name}", "#{dashboard_product_path(@product)}"
    add_breadcrumb "Editar", edit_dashboard_product_path(@product)
    add_breadcrumb "Editar inventario"
  end

  # GET /edit/variants
  def edit_variants
    set_meta_tags title: "Editar variantes de #{@product.name} | Panel de control",
                  description: "Editar variantes de #{@product.name} | Panel de control"
    add_breadcrumb "#{@product.name}", "#{dashboard_product_path(@product)}"
    add_breadcrumb "Editar", edit_dashboard_product_path(@product)
    add_breadcrumb "Editar variantes"
  end

  def create
    @product = Product.new(product_params)
    @product.status = params["product"]["status"] === "0" ? "inactive" : "active"
    @product.place = @place

    respond_to do |format|
      if @product.save
        if params["product"] and params["product"]["item_ids"].present?
          if params["product"]["status"] === "active"
            Product.update_recent_products(item_ids: params["product"]["item_ids"], product: @product, action: "create")
          end
        end
        format.html { redirect_to edit_dashboard_product_path(@product), alert: 'Se ha creado el producto' }
      else
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      @typo = params["product"]["typo"].present?
      begin
        params["product"]["status"] = params["product"]["status"] === "on" ? "active" : "inactive"
        old_items = []
        new_items = []

        status_change = params["product"]["status"] != @product.status
        puts "-----------#{status_change}------------STATUS"
        unless status_change
          if params["product"]["item_ids"].present?
            old_items = @product.item_ids.map(&:to_s)
            new_items = params["product"]["item_ids"].select { |ii| ii.length > 0 } # Hacemos parse de los items cuya longitud de string sea mayor a cero
            old_items.each do |ii|
              new_items.delete(ii)
            end
            params["product"]["item_ids"].each do |ii|
              old_items.delete(ii)
            end
          end
        end
      rescue => e
        format.html { redirect_to dashboard_product_path(@product), notice: "Ha ocurrido un error" }
      end
      if @product.update(product_params)
        if status_change # El status cambio
          if @product.status === "active" # si el status anterior es inactive y el nuevo paso a active
            new_item_ids = @product.place.items.includes(:recent_products).where(:product_ids.in => [@product.id])
            Product.update_recent_products(item_ids: new_item_ids.pluck(:id).map(&:to_s), product: @product, action: "create")
            # vamos a agregar a los productos recientes de cada item que tiene
            # Si tiene el item de "new" entonces vamos a agregar un recent product a new
          else # el status anterior era active
            # Tenemos que eliminar de todos los recent_products
            current_items = @place.items.includes(:recent_products).where(:recent_product_ids.in => [@product.id]) # traemos todos los recent_products que contengan está relación para después eliminarlos
            Product.update_recent_products(item_ids: current_items.pluck(:id).map(&:to_s), product: @product, action: "delete")
            # current_items.each do |ci|
            #   ci.recent_products.delete(@product) # eliminamos los items
            # end
          end
        end
        if new_items.length > 0 # Se agregaron nuevos elementos
          Product.update_recent_products(item_ids: new_items, product: @product, action: "create")
        end
        if old_items.length > 0 # Se eliminaron elementos - Eliminar de los recientes del item
          Product.update_recent_products(item_ids: old_items, product: @product, action: "delete")
        end
        format.js
        # format.json { render :show, status: :ok, location: @product }
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
          format.html { redirect_to edit_dashboard_product_path(@product), notice: "Ha ocurrido un error al actualizar el producto" }
        end
        format.html { redirect_to edit_dashboard_product_path(@product), alert: "Se ha actualizado el producto" }
      rescue => e
        puts "-----#{e}"
        format.html { redirect_to edit_dashboard_product_path(@product), notice: "Ha ocurrido un error al actualizar el producto" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @product.destroy
        format.html { redirect_to dashboard_products_path, alert: 'Producto eliminado correctamente' }
        format.json { head :no_content }
      else
        format.html { redirect_to dashboard_product_path(@product), notice: 'Ha ocurrido un error al eliminar el producto' }
      end
    end
  end


  private

  def set_product
    if controller_name === "products"
      @product = @place.products.find_by(id: params["id"] || params["product_id"])
    else
      @product = @place.products.find_by(id: params["product_id"])
    end
    not_found if @product.nil?
  end


  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :description, :price, :status, :weight, :aggregates_required, :sku, :max_aggregates, :public_stock, :unlimited, :quantity, :quantity_measure, item_ids: [], aggregate_categories_attributes: [:name, :id, :required, :multiple_selection, aggregates_attributes: [:name, :price, :sku, :public_stock, :quantity, :unlimited, :id]])
  end
end
