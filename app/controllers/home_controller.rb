class HomeController < ApplicationController

  layout "business", only: [:business, :pricing]

  def index
    @places = Place.where(status: "active").order_by(created_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  def business
    @free_days = ab_test(:free_pricing_upgrade, '7', '14', '30')
    @premium_pricing = ab_test(:premium_pricing_upgrade, '69', '129', '229')
  end

  def pricing

  end

end
