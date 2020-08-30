class HomeController < ApplicationController

  def index
    @places = Place.where(status: "active").order_by(created_at: :desc).paginate(page: params[:page], per_page: 20)
  end

end
