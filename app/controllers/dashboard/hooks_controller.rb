class Dashboard::HooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # TODO: ENVIAR A SECRET  whsec_7HeeZrCSj4BYpiKzMD0j2mRwbbxdt8FF


  # Webhooks de connect
  def connect
    payload = request.body.read
    event = nil
    begin
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = Stripe::Webhook.construct_event(
          payload, sig_header, "whsec_wIs0hneYxxt1F9qy3Bv9pTt1RUMJym0R"
      )
        # puts "-----------#{event}"
    rescue JSON::ParserError => e
      # Invalid payload
      puts "-----------INVALID PAYLOAD"
      # status 400
      not_found
      return
    rescue Stripe::SignatureVerificationError => e
      not_found
      return "-------------------SSSSSSSSSS"
    rescue
      not_found
      return
    end

    case event.type
    when "account.updated"
      account_updated = event.data.object
      puts "--------#{account_updated}"
      current_update = Account.update_account_hook(account_updated)
      return head :ok if current_update
      not_found if current_update === false
    else
      not_found
    end
  end

  def hooks
    payload = request.body.read
    event = nil

    begin
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = Stripe::Webhook.construct_event(
          payload, sig_header, "whsec_ALYfqVpEQJtpjKtB2VZov5a8SReYx3nm"
      )
        # puts "-----------#{event}"
    rescue JSON::ParserError => e
      # Invalid payload
      puts "-----------INVALID PAYLOAD"
      # status 400
      not_found
      return
    rescue Stripe::SignatureVerificationError => e
      not_found
      return "-------------------SSSSSSSSSS"
    rescue
      not_found
      return
    end
    if event.type.nil?
      puts "-------EVENT IS NIL"
      not_found
      return
    else
      case event.type
      when "customer.subscription.trial_will_end"
        subscription = event.data.object
        subscription_updated = Subscription.update_place_subscription(subscription["id"], {trial_will_end: true, in_free_trial: false})
        return head :ok if subscription_updated
        not_found if subscription_updated === false
      when 'payment_intent.succeeded'
        payment_intent = event.data.object # contains a Stripe::PaymentIntent
        puts 'PaymentIntent was successful!'
        # puts "---------#{payment_intent}"
        return head :ok
      when 'payment_method.attached'
        payment_method = event.data.object # contains a Stripe::PaymentMethod
        puts 'PaymentMethod was attached to a Customer!'
        # puts "---------#{payment_method}"
        return head :ok
        # ... handle other event types
      when "account.updated"
        account_updated = event.data.object
        Account.update_account_hook(account_updated)
        puts "--------ACCOUNT UPDATE"
        return head :ok
      when "customer.subscription.updated"
        subscription_updated = Subscription.update_subscription_plan(event.data.object)
        return head :ok if subscription_updated
        return not_found if subscription_updated.nil?
      when "customer.subscription.deleted"
        subscription_updated = event.data.object
        subscription_deleted = Place.cancel_subscription(subscription_updated["id"])
        return head :ok if subscription_deleted
        # return head :ok
        return not_found if subscription_deleted.nil? || subscription_deleted === false
        return
      else
        # return  head :ok
        puts "-------- UNEXPECTED"
        not_found
        return
        # render :nothing => true
      end
    end

  end

end