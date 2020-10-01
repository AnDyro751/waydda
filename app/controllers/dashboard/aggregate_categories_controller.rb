class Dashboard::AggregateCategoriesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_product
  before_action :set_aggregate_category, only: [:show, :update, :edit, :destroy]
  add_breadcrumb "Inicio", :my_place_path
  add_breadcrumb "Productos", :dashboard_products_path

  def new
    @aggregate_category = @product.aggregate_categories.new
    @aggregate_category.aggregates.new
  end

  def edit
    add_breadcrumb "#{@product.name}", :dashboard_product_path
    add_breadcrumb "Variantes", "#{dashboard_product_aggregate_categories_path(@product.slug)}"
    add_breadcrumb "#{@aggregate_category.name}", "#{dashboard_product_aggregate_category_path(@product.slug, @aggregate_category)}"
    add_breadcrumb "Editar"
  end

  def show
    add_breadcrumb "#{@product.name}", :dashboard_product_path
    add_breadcrumb "Variantes", "#{dashboard_product_aggregate_categories_path(@product.slug)}"
    add_breadcrumb "#{@aggregate_category.name}"
    @aggregate_category.aggregates.build
  end

  def index
    add_breadcrumb "#{@product.name}", "#{dashboard_product_path(@product.slug)}"
    add_breadcrumb "Variantes"
    @aggregate_categories = @product.aggregate_categories
  end

  def create
    @aggregate_category = @product.aggregate_categories.new(aggregate_category_params)
    respond_to do |format|
      if @aggregate_category.save
        format.html { redirect_to dashboard_product_aggregate_category_path(@product.slug, @aggregate_category) }
      else
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @aggregate_category.update(aggregate_category_params)
        format.html { redirect_to dashboard_product_aggregate_category_path(@product.slug, @aggregate_category), alert: "Se ha actualizado la variante" }
      else
        puts "-------#{@aggregate_category.errors.full_messages}"
        format.html { redirect_to dashboard_product_aggregate_category_path(@product.slug, @aggregate_category), notice: "Ha ocurrido un error al actualizar la variante" }
      end
    end
  end

  def destroy
    @aggregate_category.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_product_aggregate_categories_path(@product.slug), alert: "Se ha eliminado la variante" }
    end
  end

  private

  def set_product
    @product = @place.products.find_by(slug: params["product_id"])
    not_found if @product.nil?
  end

  def set_aggregate_category
    (@aggregate_category = @product.aggregate_categories.find_by(id: params["id"])) or not_found
  end

  def aggregate_category_params
    params.require(:aggregate_category).permit(:name, :required, :multiple_selection, aggregates: [], aggregates_attributes: [], aggregates_attributes: [:name, :id, :price, :_destroy])
  end

end
