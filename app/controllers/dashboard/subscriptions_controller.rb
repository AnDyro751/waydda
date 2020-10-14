class Dashboard::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_price
  before_action :set_subscription, only: [:cancel]
  skip_before_action :verify_authenticity_token, :only => [:create]

  layout "dashboard"

  def edit
    set_meta_tags title: "Mi suscripción - Ajustes | Panel de control",
                  description: "Mi suscripción - Ajustes | Panel de control"
    add_breadcrumb "Ajustes", dashboard_edit_my_place_path
    add_breadcrumb "Mi suscripción"
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
      if @place.kind === "premium" and params["subscription_id"] === "premium"
        format.json { render json: {errors: "Ya cuentas con el plan premium"}, status: :unprocessable_entity }
      end
      begin
        card_token = params["card_token"]
        if card_token.nil?
          puts "-------------DEBE"
          format.json { render json: {errors: "No se ha ingresado información bancaria"}, status: :bad_gateway }
        else
          if card_token
            current_source = Account.create_source(current_user.stripe_customer_id, params["card_token"])
            if current_source.nil?
              format.json { render json: {errors: "Ha ocurrido un error al suscribirte"}, status: :unprocessable_entity }
            else
              updated_account = Account.update_account(current_user.stripe_customer_id, {
                  default_source: current_source["id"]
              })
              puts "---------#{updated_account[:success]} UPDATED"
              if updated_account[:success]
                current_user.update(default_source: {id: updated_account["default_source"]})
              else
                format.json { render json: {errors: "Ha ocurrido un error al suscribirte"}, status: :unprocessable_entity }
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
                                                               trial_from_plan: true
                                                           })
          rescue
            format.json { render json: {errors: "Ha ocurrido un error al suscribirte"}, status: :unprocessable_entity }
          end
          current_subscription = @place.subscription
          if current_subscription
            puts "--------------__#{new_subscription}------------SUBSCRIPTION"
            if current_subscription.update(kind: "premium", stripe_subscription_id: new_subscription["id"], trial_end: new_subscription["trial_end"], trial_start: new_subscription["trial_start"])
              @place.update(kind: "premium", trial_will_end: false, in_free_trial: @place.trial_used ? false : true, trial_used: true)
              @success = true
              puts "----------------4"
              format.json { render json: {errors: nil, success: true}, status: :ok }
            else
              puts "----------------3"
              format.json { render json: {errors: "Ha ocurrido un error al suscribirte", success: false}, status: :unprocessable_entity }
            end
          else
            puts "--------------__#{new_subscription}------------SUBSCRIPTION"
            @subscription = @place.create_subscription(stripe_subscription_id: new_subscription["id"], kind: "premium", trial_end: new_subscription["trial_end"], trial_start: new_subscription["trial_start"])
            if @subscription.save
              @success = true
              @place.update(kind: "premium", trial_will_end: false, in_free_trial: @place.trial_used ? false : true, trial_used: true)
              puts "----------------5"
              format.json { render json: {errors: nil, success: true}, status: :ok }
            else
              puts "----------------2"
              format.json { render json: {errors: "Ha ocurrido un error al suscribirte", success: false}, status: :unprocessable_entity }
            end
          end
        end


      rescue => e
        puts "Error --------#{e}------"
        format.json { render json: {errors: "Ha ocurrido un error al suscribirte", success: false}, status: :unprocessable_entity }
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
