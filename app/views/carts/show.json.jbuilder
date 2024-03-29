# carts: @carts, items: [], total: @total, current_address: @current_address
json.carts(@carts) do |cart|
  json.delivery_option cart["delivery_option"]
  json.items cart["items"] do |item|
    json.(item, :quantity)
    json.product_record item["product_record"]
  end
  json.place_record cart["place_record"], :name, :lat, :lng, :slug, :photo, :cover, :delivery_option, :delivery_cost, :delivery_distance, :delivery_extra_cost, :address
  json.quantity cart["quantity"]
  json.total Cart.get_total(cart["items"])
end
json.total @total
json.current_address @current_address
