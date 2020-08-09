Rails.application.routes.draw do
  root 'home#index'

  # users
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "/my-profile", to: "users#my_profile", as: "my_profile"
  get "/my-profile/edit", to: "users#edit", as: "edit_my_profile"

  resources :addresses
  #cart
  post "/add_to_cart/:product_id", to: "carts#add_product", as: "add_product_to_cart"
  get "/cart", to: "carts#show", as: "my_cart"
  resources :users, only: [:show, :update] do
    collection do
      patch 'update_password'
    end
  end
  resources :places, only: [:show, :index]

  # Dashboard
  get "/dashboard", to: "dashboard/places#my_place", as: "my_place" # Index dashboard
  put "/dashboard", to: "dashboard/places#update"
  namespace :dashboard do
    # Uploads
    post "/upload/:model/:slug/:attribute", to: "image#upload", as: "upload_image"
    # Items
    resources :items
    # Products
    resources :products do
      # TODO: Crud operations
      resources :aggregates
    end
    # Places
    resources :places, only: [:edit, :update, :new, :create] do
      patch "/update_slug", to: "places#update_slug", as: "update_slug"
    end
  end

end
