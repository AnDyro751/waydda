class Dashboard::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_price
  skip_before_action :verify_authenticity_token, :only => [:create]
  layout "dashboard"


  def new
    @subscription = current_user.subscriptions.new
    # TODO: Verificar que el stripe_customer_id esté presente o crear un customer
  end

  def create
    respond_to do |format|
      if current_user.default_source.empty?
        card_token = params["card_token"]
        if card_token.nil?
          puts "---------NO SE HA ENVIADO TOKEN"
          format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
        end
        current_source = Account.create_source(current_user.stripe_customer_id, params["card_token"])
        if current_source.nil?
          format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
        else
          updated_account = Account.update_account(current_user.stripe_customer_id, {
              default_source: current_source["id"]
          })
          puts "---------#{updated_account[:success]} UPDATED"
          if updated_account[:success]
            current_user.update(default_source: {id: updated_account["default_source"]})
          else
            format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
          end
          # TODO: Guardar el default token que recibimos como param
        end
      end
      begin
        # TODO: Actualizar la suscripción a la que le tocó
        Stripe::Subscription.create({
                                        customer: current_user.stripe_customer_id,
                                        items: [
                                            {
                                                price: Account.get_price(free_days: @free_days.to_i, price: @premium_pricing.to_i)
                                            },
                                        ],
                                    })
        @place.to_premium!
        format.html { redirect_to my_place_path, alert: "¡Se ha actualizado tu suscripción!" }
      rescue => e
        puts "Error --------#{e}------"
        # format.js
        format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
      end
    end
  end

end
