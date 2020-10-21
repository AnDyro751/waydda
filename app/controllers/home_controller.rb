class HomeController < ApplicationController
  layout "business", only: [:business, :pricing]
  before_action :set_price

  def index
    set_meta_tags title: "Waydda México",
                  description: "Waydda México"
    @places = Place.where(status: "active").order_by(created_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  def business
  end

  def pricing

  end

end
