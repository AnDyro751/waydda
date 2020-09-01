class HomeController < ApplicationController

  layout "business", only: [:business, :pricing]

  def index
    @places = Place.where(status: "active").order_by(created_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  def business

  end

  def pricing

  end

end
