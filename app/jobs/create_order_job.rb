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
    cart = this_order.cart
    cart_items = cart.cart_items.includes(:product)
    cart_items.each do |ci|
      this_order.products << ci.product
    end
  end
end
