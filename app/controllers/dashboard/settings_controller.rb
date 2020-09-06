class Dashboard::SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_place
  layout "dashboard"
  def general
  end

end
