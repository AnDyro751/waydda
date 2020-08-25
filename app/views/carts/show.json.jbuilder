# carts: @carts, items: [], total: @total, current_address: @current_address
json.carts(@carts) do |cart|
  json.items cart["items"] do |item|
    json.(item, :quantity)
    json.product item["product_record"]
  end
  json.place_record cart["place_record"], :name, :lat, :lng, :photo, :cover, :delivery_option, :delivery_cost, :delivery_distance, :delivery_extra_cost, :address
  json.quantity cart["quantity"]
  json.total Cart.get_total(cart["items"])
end
json.total @total
json.current_address @current_address
