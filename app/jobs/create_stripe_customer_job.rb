class CreateStripeCustomerJob < ApplicationJob
  queue_as :default

  def perform(user)
    Stripe.api_key = 'sk_test_nLhx5k3K0NFLM06YC7nZAQVW003TPd9B70'

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
