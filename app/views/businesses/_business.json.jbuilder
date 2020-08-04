json.extract! business, :id, :name, :address, :slug, :user_id, :status, :created_at, :updated_at
json.url business_url(business, format: :json)
