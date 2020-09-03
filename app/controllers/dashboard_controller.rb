class DashboardController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!, only: [:index]
  # skip_before_action :verify_authenticity_token, only: [:hooks]

  def index

  end


end
