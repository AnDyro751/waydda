class Dashboard::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_price
  before_action :set_subscription, only: [:cancel]
  skip_before_action :verify_authenticity_token, :only => [:create]

  layout "dashboard"

  def edit

  end

  def cancel
    respond_to do |format|
      begin
        current_subscription = Place.cancel_subscription(@subscription.stripe_subscription_id)
        if current_subscription
          format.html { redirect_to dashboard_edit_subscription_path, alert: "Se ha cancelado tu suscripción" }
        else
          format.html { redirect_to dashboard_edit_subscription_path, notice: "Ha ocurrido un error al cancelar tu suscripción" }
        end
      rescue => e
        format.html { redirect_to dashboard_edit_subscription_path, notice: "Ha ocurrido un error al cancelar tu suscripción: #{e}" }
      end
    end
  end

  def new
    if @place.premium? and params["subscription_id"] === "premium"
      redirect_to dashboard_edit_subscription_path, notice: "Ya cuentas con el plan premium"
    end
    if @place.subscription.nil?
      @subscription = @place.build_subscription
    end
    # TODO: Verificar que el stripe_customer_id esté presente o crear un customer
  end

  def create
    respond_to do |format|
      # if current_user.default_source.empty?
      #   card_token = params["card_token"]
      #   if card_token.nil?
      #     puts "---------NO SE HA ENVIADO TOKEN"
      #     format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
      #   end
      #   current_source = Account.create_source(current_user.stripe_customer_id, params["card_token"])
      #   if current_source.nil?
      #     format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
      #   else
      #     updated_account = Account.update_account(current_user.stripe_customer_id, {
      #         default_source: current_source["id"]
      #     })
      #     puts "---------#{updated_account[:success]} UPDATED"
      #     if updated_account[:success]
      #       current_user.update(default_source: {id: updated_account["default_source"]})
      #     else
      #       format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
      #     end
      #     # TODO: Guardar el default token que recibimos como param
      #   end
      # end
      begin
        card_token = params["card_token"]
        if @place.trial_used and card_token.nil?
          return format.html { redirect_to dashboard_new_subscription_path("premium"), notice: "Ya se ha utilizado la prueba gratuita." }

        else
          if card_token
            current_source = Account.create_source(current_user.stripe_customer_id, params["card_token"])
            if current_source.nil?
              format.html { redirect_to dashboard_new_subscription_path("premium"), notice: "Ha ocurrido un error al suscribirte" }
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
            new_subscription = Stripe::Subscription.create({
                                                               customer: current_user.stripe_customer_id,
                                                               items: [
                                                                   {
                                                                       price: Account.get_price(free_days: @free_days.to_i, price: @premium_pricing.to_i)
                                                                   },
                                                               ],
                                                               trial_from_plan: @place.trial_used ? false : true
                                                           })
          rescue
            format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
          end
          current_subscription = @place.subscription
          if current_subscription
            if current_subscription.update(kind: "premium", stripe_subscription_id: new_subscription["id"], trial_end: new_subscription["trial_end"], trial_start: new_subscription["trial_start"])
              @place.update(kind: "premium", trial_will_end: false, in_free_trial: @place.trial_used ? false : true, trial_used: true)
              format.html { redirect_to my_place_path, alert: "¡Se ha actualizado tu suscripción!" }
            else
              format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
            end
          else
            @subscription = @place.create_subscription(stripe_subscription_id: new_subscription["id"], kind: "premium", trial_end: new_subscription["trial_end"], trial_start: new_subscription["trial_start"])
            if @subscription.save
              @place.update(kind: "premium", trial_will_end: false, in_free_trial: @place.trial_used ? false : true, trial_used: true)
              format.html { redirect_to my_place_path, alert: "¡Se ha actualizado tu suscripción!" }
            else
              format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
            end
          end
        end


      rescue => e
        puts "Error --------#{e}------"
        # format.js
        format.html { redirect_to dashboard_upgrade_plan_path, notice: "Ha ocurrido un error al suscribirte" }
      end
    end
  end

  private

  def set_subscription
    @subscription = @place.subscription
    if @subscription.nil?
      redirect_to dashboard_edit_subscription_path, notice: "Ha ocurrido un error al cancelar tu suscripción"
    end
  end

end
