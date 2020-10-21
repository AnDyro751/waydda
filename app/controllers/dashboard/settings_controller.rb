class Dashboard::SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_place, only: [:general, :danger, :shipping]
  layout "dashboard"

  def general
    set_meta_tags title: "General - Ajustes | Panel de control",
                  description: "General - Ajustes | Panel de control"
    add_breadcrumb "Ajustes", dashboard_edit_my_place_path
    add_breadcrumb "General"
  end

  def danger
    set_meta_tags title: "Zona de peligro - Ajustes | Panel de control",
                  description: "Zona de peligro - Ajustes | Panel de control"
    add_breadcrumb "Ajustes", dashboard_edit_my_place_path
    add_breadcrumb "Zona de peligro"
  end

  def shipping
    set_meta_tags title: "Envíos - Ajustes | Panel de control",
                  description: "Envíos - Ajustes | Panel de control"
    add_breadcrumb "Ajustes", dashboard_edit_my_place_path
    add_breadcrumb "Envíos"
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


  private


end
