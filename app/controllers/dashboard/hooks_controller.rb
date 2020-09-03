class Dashboard::HooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # TODO: ENVIAR A SECRET  whsec_7HeeZrCSj4BYpiKzMD0j2mRwbbxdt8FF
  def hooks
    payload = request.body.read
    event = nil

    begin
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = Stripe::Webhook.construct_event(
          payload, sig_header, "whsec_Jgk5j3JHXzqn22lRMWqVD4mQzHzBMz17"
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
      when 'payment_intent.succeeded'
        payment_intent = event.data.object # contains a Stripe::PaymentIntent
        puts 'PaymentIntent was successful!'
        puts "---------#{payment_intent}"
        return head :ok
      when 'payment_method.attached'
        payment_method = event.data.object # contains a Stripe::PaymentMethod
        puts 'PaymentMethod was attached to a Customer!'
        puts "---------#{payment_method}"
        return head :ok
        # ... handle other event types
      when "account.updated"
        puts "--------ACCOUNT UPDATE"
        return head :ok
      else
        puts "-------- UNEXPECTED"
        not_found
        return
        # render :nothing => true
      end
    end

  end

end