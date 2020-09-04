class CreateStripeCustomerJob < ApplicationJob
  queue_as :default

  def perform(user)
    Stripe.api_key = 'sk_test_51H9CZeBOcPJ0nbHctTzfQZhFXBnn8j05e0xqJ5RSVz5Bum72LsvmQKIecJnsoHISEg0jUWtKjERYGeCAEWiIAujP00Fae9MiKm'

    begin
      stripe_customer = Stripe::Customer.create({
                                                    description: "User customer - #{user.id.to_s}",
                                                    email: user.email,
                                                    name: user.name
                                                })
      user.update(stripe_customer_id: stripe_customer["id"])
    rescue => e
      puts "--------#{e}"
    end
    # Do something later
  end
end
