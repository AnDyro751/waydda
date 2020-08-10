class Checkout
  include Mongoid::Document
  include Mongoid::Timestamps
  # fields
  field :status, type: String, default: "pending"

  # relations
  embedded_in :cart
  embeds_one :address
  # validations
  validates :status, inclusion: {in: %w[pending active]}


  def self.create_or_get_checkout(current_cart)
    current_checkout = current_cart.checkout
    if current_checkout.nil?
      begin
        current_checkout = current_cart.create_checkout
        return current_checkout
      rescue
        return nil
      end
    else
      return current_checkout
    end
  end

end
