class Dashboard::AggregatesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_product
  before_action :set_aggregate_category, only: [:show, :update, :edit, :destroy, :new, :create, :index]
  before_action :set_aggregate, only: [:show, :update, :edit, :destroy]
  add_breadcrumb "Productos", :dashboard_products_path, only: [:new]

  def new
    set_meta_tags title: "Nueva subvariante de #{@aggregate_category.name} | Panel de control",
                  description: "Nueva subvariante de #{@aggregate_category.name} | Panel de control"
    add_breadcrumb "#{@product.name}", "#{dashboard_product_path(@product)}"
    add_breadcrumb "Variantes", "#{dashboard_product_aggregate_categories_path(@product)}"
    add_breadcrumb "#{@aggregate_category.name}", "#{dashboard_product_aggregate_categories_path(@product, @aggregate_category)}"
    add_breadcrumb "Nueva subvariante", "#{new_dashboard_product_aggregate_category_aggregate_path(@product, @aggregate_category)}"
    @aggregate = @aggregate_category.aggregates.new
    # respond_to do |format|
    #   format.js
    # end
  end

  def show

  end

  def edit
    set_meta_tags title: "Editar subvariante de #{@aggregate_category.name} | Panel de control",
                  description: "Editar subvariante de #{@aggregate_category.name} | Panel de control"
    add_breadcrumb "#{@product.name}", "#{dashboard_product_path(@product)}"
    add_breadcrumb "Variantes", "#{dashboard_product_aggregate_categories_path(@product)}"
    add_breadcrumb "#{@aggregate_category.name}", "#{dashboard_product_aggregate_categories_path(@product, @aggregate_category)}"
    add_breadcrumb "Subvariantes", "#{dashboard_product_aggregate_category_aggregates_path(@product, @aggregate_category)}"
    add_breadcrumb "#{@aggregate.name}", "#{dashboard_product_aggregate_category_aggregates_path(@product, @aggregate_category, @aggregate)}"
    add_breadcrumb "Editar"
    respond_to do |format|
      format.js
      format.html
    end
  end

  def index
    @aggregates = @aggregate_category.aggregates
  end

  def create
    @redirect_to = @aggregate_category.aggregates.length <= 0
    @aggregate = @aggregate_category.aggregates.new(aggregate_params)

    respond_to do |format|
      if @aggregate.save
        if @redirect_to
          format.html { redirect_to dashboard_product_aggregate_category_path(@product, @aggregate_category), alert: "Se ha creado la subvariante" }
        else
          format.js
        end
      else
        # format.html { render :new }
        format.js
        # format.json { render json: @aggregate.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @aggregate.update(aggregate_params)
        # format.js
        format.html { redirect_to dashboard_product_aggregate_category_path(@product, @aggregate_category), alert: 'Se ha actualizado la subvariante' }
        format.json { render :show, status: :ok, location: @place }
      else
        # format.js
        format.html { redirect_to dashboard_product_aggregate_category_aggregate_path_path(@product, @aggregate_category, @aggregate), notice: 'Ha ocurrido un error al actualizar la subvariante' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @aggregate_id = @aggregate.id.to_s

    respond_to do |format|
      begin
        @aggregate.destroy
        @error = false
        format.js
      rescue
        @error = true
        format.js
      end
      # format.json { head :no_content }
    end
  end

  private

  def aggregate_params
    params.require(:aggregate).permit(:name, :description, :price, :default, :add_to_price_product, :photo, :sku, :public_stock, :quantity, :unlimited)
    # :sku, :public_stock, :quantity, :unlimited
    # :sku, :public_stock, :quantity, :unlimited
  end

  def set_aggregate
    @aggregate = @aggregate_category.aggregates.find(params["id"])
    not_found if @aggregate.nil?
  end

  def set_aggregate_category
    @aggregate_category = @product.aggregate_categories.find(params["aggregate_category_id"])
    not_found if @aggregate_category.nil?
  end

  def set_product
    @product = @place.products.find_by(slug: params["product_id"])
    not_found if @product.nil?
  end

end