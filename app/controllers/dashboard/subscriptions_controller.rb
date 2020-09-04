class Dashboard::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_place
  layout "dashboard"

  def new
    # TODO: Verificar que el stripe_customer_id esté presente o crear un customer
  end

  def create
    respond_to do |format|
      begin
        Stripe::Subscription.create({
                                        customer: current_user.stripe_customer_id,
                                        items: [
                                            {
                                                price: 'price_1HNSEGKgRp6iAMUdUuOPYSjX'
                                            },
                                        ],
                                    })
        format.html { redirect_to my_place_path, alert: "¡Se ha actualizado tu suscripción!", status: :unprocessable_entity }
      rescue => e
        format.html { redirect_to dashboard_new_subscription_path, notice: "Ha ocurrido un error al suscribirte", status: :unprocessable_entity }
        puts "Error --------#{e}"
      end
    end
  end


end
