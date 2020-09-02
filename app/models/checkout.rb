class Checkout
  include Mongoid::Document
  include Mongoid::Timestamps
  Stripe.api_key = 'sk_test_nLhx5k3K0NFLM06YC7nZAQVW003TPd9B70'

  # fields
  field :status, type: String, default: "pending"

  # relations
  embedded_in :cart
  embeds_one :address
  # validations
  validates :status, inclusion: {in: %w[pending active]}

  def self.update_intent(current_cart, new_amount)
    begin
      Stripe::PaymentIntent.update(current_cart.intent_id,
                                   {
                                       amount: (new_amount * 100).to_i
                                   }
      )
      return true
    rescue => e
      puts "-------------------------------ERROR #{e}"
      return nil
    end
  end

  # @param [Object] current_cart
  # @return [Object] client_secret - Stripe
  def self.get_intent(current_cart)
    if current_cart.intent_id.nil?
      items = current_cart.cart_items.includes(:product)
      return Checkout.create_intent(items, current_cart)
    else
      return [current_cart.intent_id, current_cart.client_secret]
    end
  end

  # @param [Object] items
  # @param [Object] current_cart
  # @return [String] payment_intent_client secret - Stripe
  def self.create_intent(items, current_cart)
    total = Cart.get_total(items)
    return nil if total <= 0
    begin
      payment_intent = Stripe::PaymentIntent.create(
          setup_future_usage: 'off_session',
          amount: (total * 100).to_i,
          currency: 'mxn'
      )
    rescue => e
      puts "----------------#{e}"
      return nil
    end
    current_cart.update(intent_id: payment_intent["id"], client_secret: payment_intent["client_secret"])
    return [payment_intent["id"], payment_intent['client_secret']]
  end

  # @param [Object] current_cart
  def self.cancel_intent(current_cart)
    Stripe::PaymentIntent.cancel(current_cart.intent_id)
    current_cart.update(intent_id: nil, client_secret: nil)
  end

end
