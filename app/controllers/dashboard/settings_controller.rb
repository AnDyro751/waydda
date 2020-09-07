class Dashboard::SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_place, only: [:general, :danger]
  layout "dashboard"

  def general
  end

  def danger
  end

  def create_portal
    respond_to do |format|
      @billing_url = Account.generate_billing_url(current_user.stripe_customer_id)
      if @billing_url.nil?
        format.html { redirect_to dashboard_edit_subscription_path, notice: "Ha ocurrido un error al redirigir a tu panel de control" }
      else
        format.js
      end
    end
  end

end
