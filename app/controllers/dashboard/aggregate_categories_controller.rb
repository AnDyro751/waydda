class Dashboard::AggregateCategoriesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_product
  before_action :set_aggregate_category, only: [:show, :update, :edit, :destroy]

  def new
  end

  def edit
  end

  def show

  end

  private

  def set_product
    @product = @place.products.find_by(slug: params["product_id"])
    not_found if @product.nil?
  end

  def set_aggregate_category
    (@aggregate_category = @product.aggregate_categories.find_by(id: params["id"])) or not_found
  end

end
