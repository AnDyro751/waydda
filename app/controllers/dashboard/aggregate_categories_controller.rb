class Dashboard::AggregateCategoriesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_product
  before_action :set_aggregate_category, only: [:show, :update, :edit, :destroy]

  def new
    @aggregate_category = @product.aggregate_categories.new
  end

  def edit
  end

  def show
  end

  def index
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
    params.require(:aggregate_category).permit(:name, :required, :multiple_selection, :description)
  end

end
