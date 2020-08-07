json.extract! place, :id, :name, :address, :slug, :status, :location, :photo, :cover, :total_items, :total_products
json.url dashboard_place_path(place, format: :json)