class DashboardController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!, except: [:show]

  def index

  end

end
