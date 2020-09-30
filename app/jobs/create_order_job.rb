class CreateOrderJob < ApplicationJob
  queue_as :default

  # @note
  # Crea la orden para mostrarla al admin de la empresa

  # TODO: Mandar email de confirmación

  # @param [Object] this_order
  def perform(this_order)
    cart = this_order.cart
    cart_items = cart.cart_items.includes(:product)
    new_products = []
    cart_items.each do |ci|
      # Cart item tiene los aggregates que podemos buscar
      product = ci.product.attributes
      new_aggregates = AggregateCategory.get_all_aggregate_categories_and_aggregates(aggregates: ci.aggregates, product: ci.product)
      # total = 0

      # new_aggregates.each do |agg|
      #   agg[:subvariants].each do |sb|
      #     total = total + sb["price"]
      #   end
      # end
      # total = total + ci.product.price
      begin
        this_order.order_items << this_order.order_items.create(product: ci.product, aggregates: new_aggregates, quantity: ci.quantity)
      rescue => e
        puts "------------------_#{e}"
      end
    end
  end
end
