class Dashboard::AggregatesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_product

  def new
    @aggregate = @product.aggregates.new
  end


  private

  def set_product
    @product = @place.products.find_by(slug: params["product_id"])
    not_found if @product.nil?
  end

end