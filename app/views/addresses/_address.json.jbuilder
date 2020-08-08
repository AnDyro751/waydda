json.extract! address, :id, :street, :city, :country, :location, :created_at, :updated_at, :default
json.url address_url(address, format: :json)
