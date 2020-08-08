Rails.application.routes.draw do

  root 'home#index'


  # users
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "/my-profile", to: "users#my_profile", as: "my_profile"
  resources :addresses
  resources :users, only: [:show, :update]
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
