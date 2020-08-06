Rails.application.routes.draw do

  get 'image/upload'
  # mount Shrine.presign_endpoint(:cache) => "/s3/params"

  get "/dashboard", to: "dashboard/places#my_place", as: "my_place" # Index dashboard
  put "/dashboard", to: "dashboard/places#update"
  namespace :dashboard do
    # Uploads
    post "/upload/:model/:slug/:attribute", to: "image#upload", as: "upload_image"
    # Items
    resources :items
    # Products
    resources :products
    # Places
    resources :places#, only: [:edit, :update]
    # get "my-place", to: "places#my_place", as: "my_place"
  end
  # resources :places, only: [:show, :index]
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  # dashboard/my-place
  # dashboard/products/
  # dashboard/products/:id
  # dashboard/items
  # dashboard/items/:id
  # dashboard/products/new?item_id=item_id <- item_id para el id que se va a seleccionar
end
