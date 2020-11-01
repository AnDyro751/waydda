class Dashboard::SalesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place



  def show
  end

  def edit
  end

end
