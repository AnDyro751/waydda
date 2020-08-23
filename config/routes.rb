Rails.application.routes.draw do
  get 'searchs/show'
  root 'home#index'
  # search
  get "/search", to: "searchs#show", as: "search"
  # users
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks", sessions: "users/sessions"}
  devise_scope :user do
    get 'acceder', to: 'users/sessions#new' #, as: :new_user_session
  end
  get "/my-profile", to: "users#my_profile", as: "my_profile"
  get "/my-profile/edit", to: "users#edit", as: "edit_my_profile"
  resources :users, only: [:show, :update] do
    collection do
      patch 'update_password'
    end
  end
  #Address
  resources :addresses

  #cart
  delete "/delete_product/:product_id", to: "carts#delete_product", as: "delete_product_to_cart"
  put "/update_item/:item_id", to: "carts#update_item", as: "update_item_to_cart"
  post "/add_to_cart/:product_id", to: "carts#add_product", as: "add_product_to_cart"

  # checkouts
  get 'checkout', to: "checkouts#show"
  resources :checkouts, only: [:show, :create]

  #Public places
  resources :places, only: [:show, :index] do
    resources :products
    get "/cart", to: "carts#show", as: "my_cart"
    post "/cart", to: "carts#create_charge", as: "create_charge"
  end

  # Dashboard
  get "/dashboard", to: "dashboard/places#my_place", as: "my_place" # Index dashboard
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
    get "/my-sales", to: "places#sales", as: "my_sales"
    get "/edit", to: "places#edit", as: "edit_my_place"
    resources :places, only: [:edit, :update, :new, :create] do
      patch "/update_slug", to: "places#update_slug", as: "update_slug"
    end


  end
  # get "/react-router(*all)", to: "home#react", as: "react"

end
