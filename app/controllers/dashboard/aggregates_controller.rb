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

  def index
    @aggregates = @product.aggregates
  end

  def create
    # TODO: Si el aggregate.default = true vamos a desactivar el aggregate default anterior y pasarlo a false
    @aggregate = @product.aggregates.new(aggregate_params)
    respond_to do |format|
      if @aggregate.save
        format.html { redirect_to dashboard_product_aggregates_path(@product.slug), notice: 'Aggregate was successfully created.' }
        format.json { render :show, status: :created, location: @aggregate }
      else
        format.html { render :new }
        format.json { render json: @aggregate.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @aggregate.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_product_aggregates_path(@product.slug), notice: 'Producto eliminado correctamente' }
      format.json { head :no_content }
    end
  end

  private

  def aggregate_params
    params.require(:aggregate).permit(:name, :description, :price, :default)
  end

  def set_aggregate
    @aggregate = @product.aggregates.find_by(id: params["id"])
    not_found if @aggregate.nil?
  end

  def set_product
    @product = @place.products.find_by(slug: params["product_id"])
    not_found if @product.nil?
  end

end