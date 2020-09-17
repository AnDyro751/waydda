class Dashboard::AggregatesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_product
  before_action :set_aggregate, only: [:show, :update, :edit, :destroy]

  def new
    @aggregate = @product.aggregates.new
  end

  def show

  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def index
    @aggregates = @product.aggregates
  end

  def create
    # TODO: Si el aggregate.default = true vamos a desactivar el aggregate default anterior y pasarlo a false
    @aggregate = @product.aggregates.new(aggregate_params)
    respond_to do |format|
      if @aggregate.save
        format.html { redirect_to dashboard_product_aggregates_path(@product.slug), alert: 'Se ha creado la variante.' }
        format.json { render :show, status: :created, location: @aggregate }
      else
        format.html { render :new }
        format.js
        format.json { render json: @aggregate.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @aggregate.update(aggregate_params)
        format.js
        format.html { redirect_to dashboard_product_aggregate_path(@product.slug, @aggregate), notice: 'Aggregate was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.js
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @aggregate.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_product_aggregates_path(@product.slug), alert: 'Se ha eliminado la variante' }
      format.json { head :no_content }
    end
  end

  private

  def aggregate_params
    params.require(:aggregate).permit(:name, :description, :price, :default, :add_to_price_product, :photo)
  end

  def set_aggregate
    @aggregate_category = @product.aggregate_categories.find(params["aggregate_category_id"])
    not_found if @aggregate_category.nil?
    @aggregate = @aggregate_category.aggregates.find_by(id: params["id"])
    not_found if @aggregate.nil?
  end

  def set_product
    @product = @place.products.find_by(slug: params["product_id"])
    not_found if @product.nil?
  end

end