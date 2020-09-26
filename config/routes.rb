Rails.application.routes.draw do

  root 'home#index'
  # TODO: Agregar seguridad a esto
  mount Split::Dashboard, at: 'split'
  # Business
  get "/business", to: "home#business", as: :home_business
  get "/pricing", to: "home#pricing", as: :price_business

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
  # delete "/delete_product/:product_id", to: "carts#delete_product", as: "delete_product_to_cart"
  # put "/update_item/:item_id", to: "carts#update_item", as: "update_item_to_cart"
  # post "/add_to_cart/:place_id/:product_id", to: "carts#add_product", as: "add_product_to_cart"

  # checkouts
  get 'checkout', to: "checkouts#show"
  resources :checkouts, only: [:show, :create]
  get "/cart", to: "carts#show", as: "my_public_cart"

  #Public places
  resources :places, only: [:show, :index], path: "place" do
    get "/catalog", to: "places#catalog", as: :catalog
    put '/:cart_id/delivery-options', to: "delivery_options#update", as: "delivery_options"
    resources :products do
      post "/cart/add_item", to: "carts#add_product", as: "add_to_cart"
    end

    patch "/cart/:cart_item_id/update_item", to: "carts#update_item", as: "update_cart_item"
    get "/cart", to: "carts#show", as: "my_cart"
    # get "/cart/edit", to: "carts#show", as: "edit_my_cart"
    post "/cart", to: "carts#create_charge", as: "create_charge"
    get "/:cart_id/success", to: "carts#success", as: "success_checkout"
    put "/cart/payment-method", to: "carts#payment_method", as: "update_payment_method"
  end

  # Dashboard
  get "/dashboard", to: "dashboard/places#my_place", as: "my_place" # Index dashboard
  # Webhooks
  post "/hooks", to: "dashboard/hooks#hooks"
  post "/hooks_connect", to: "dashboard/hooks#connect"
  # mount StripeEvent::Engine, at: '/hooks'
  namespace :dashboard do
    # Uploads
    post "/upload/:model/:slug/:attribute", to: "image#upload", as: "upload_image"
    get "/upgrade", to: "places#upgrade", as: :upgrade_plan
    get "/upgrade/:subscription_id", to: "subscriptions#new", as: :new_subscription
    post "/upgrade/:subscription_id", to: "subscriptions#create", as: :create_subscription
    # Items
    resources :items
    resources :subscriptions, only: [:new]
    # Products
    resources :products do
      # TODO: Crud operations
      post "/update_status", to: "products#update_status", as: :update_status
      resources :aggregate_categories, :path => 'variants' do
        resources :aggregates
      end
    end
    # Places
    get "/my-sales", to: "places#sales", as: "my_sales"

    get "/settings", to: "places#edit", as: "edit_my_place"
    get "/settings/general", to: "settings#general", as: "edit_general_my_place"
    get "/settings/shipping", to: "settings#shipping", as: "edit_shipping"
    get "/settings/danger", to: "settings#danger", as: "danger_zone"
    get "/settings/subscription", to: "subscriptions#edit", as: "edit_subscription"
    post "/settings/subscription", to: "settings#create_portal", as: "create_user_portal"

    # Delete subscription
    delete "settings/subscription", to: "subscriptions#cancel", as: :cancel_subscription
    # Stripe connect
    get "/settings/payments/connect", to: "places#connect", as: :place_connect
    post "/settings/payments/connect", to: "places#create_stripe_account", as: :place_create_connect
    post "/settings/payments/connect/link", to: "places#create_account_link", as: :place_create_link

    resources :places, only: [:edit, :update, :new, :create, :index] do
      patch "/update_slug", to: "places#update_slug", as: "update_slug"
      patch "/update_delivery", to: "places#update_delivery", as: :update_delivery
    end


  end
  # get "/react-router(*all)", to: "home#react", as: "react"

end
