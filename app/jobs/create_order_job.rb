class CreateOrderJob < ApplicationJob
  queue_as :default

  # Info
  # Crea la orden para mostrarla al admin de la empresa

  # TODO: Mandar email de confirmación

  # @param [Object] place
  # @param [Object] user
  # @param [Object] address
  # @param [Object] cart
  def perform(this_order)
    # cart_items = cart.cart_items.includes(:product)
    # order = place.orders.create(user: user, address: address, cart: cart)
    # cart_items.each do |ci|
    #   order.products << ci.product
    # end
  end
end
