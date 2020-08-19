json.extract! address, :id, :address, :city, :country, :lat, :lng, :created_at, :updated_at, :default
json.url address_url(address, format: :json)
