class Dashboard::LoyaltiesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place

  def index
  end
end
