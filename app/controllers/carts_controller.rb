class CartsController < ApplicationController
  layout "cart"
  Stripe.api_key = 'sk_test_51H9CZeBOcPJ0nbHctTzfQZhFXBnn8j05e0xqJ5RSVz5Bum72LsvmQKIecJnsoHISEg0jUWtKjERYGeCAEWiIAujP00Fae9MiKm'
  before_action :set_current_cart, only: [:create_charge, :add_product]
  skip_before_action :verify_authenticity_token, only: [:show, :update_item, :add_product]

  def show
    respond_to do |format|
      @carts = current_user.carts.includes(:place, cart_items: [:product]).to_a
      format.html { render :show }
      format.json { render json: {carts: @carts, items: [], total: 0, current_address: @current_address} }
    end
  end


  def create_charge
    @items = @current_cart.cart_items.includes(:model).to_a
    @total = Cart.get_total(@items)
    respond_to do |format|
      if @current_address.nil?
        format.json { render json: {errors: "Ingresa una dirección de entrega"}, status: :unprocessable_entity }
      end
      if @total <= 0
        format.json { render json: {errors: "El carrito está vacío"}, status: :unprocessable_entity }
      end
      if params["token_id"].nil?
        format.json { render json: {errors: "Ha ocurrido un error al crear el cargo"}, status: :unprocessable_entity }
      end
      begin
        Stripe::Charge.create({
                                  amount: (@total * 100).to_i,
                                  currency: 'mxn',
                                  source: params["token_id"],
                                  description: "Waydda México",
                              })
        #TODO: Actualizar carrito al aceptar el pago
        # Validar la dirección de entrega
        # Mandar el job con los datos del user y el address
        # Eliminar el carrito del user
        # Agregar otro carrito al user
        # Nueva sesión del carrito

        CreateOrderJob.perform_later(@current_address.attributes, current_user.attributes, @current_cart.attributes) # Mandar el job para agregar la orden
        new_cart = Cart.create(user: current_user)
        current_user.cart = new_cart
        session[:cart_id] = new_cart.id.to_s
        @current_cart = new_cart

        format.json { render json: {errors: nil, success: true}, status: :created }
      rescue => e
        puts "-------#{e}"
        format.json { render json: {errors: "Ha ocurrido un error al crear el cargo"}, status: :unprocessable_entity }
      end
    end
  end

  def add_product
    #Agregar producto
    # Al current user le buscamos un carrito con el place actual
    # Si lo encontramos retornamos
    # De lo contrario creamos un carrito con el place actual y retornamos
    # Buscamos si el carrito tiene un item como el que estamos añadiendo
    # Si lo tiene aumentamos a uno
    # De lo contrario creamos un item nuevo

    respond_to do |format|
      if @current_cart.nil?
        place = Place.find_by(id: params["place_id"])
        if place.nil?
          format.html { redirect_to root_path, alert: "Ha ocurrido un error al agregar el producto", status: :not_found }
        end
        @current_cart = current_user.carts.create(place: place)
      end
      response = @current_cart.update_item(params["product_id"], 1, true)
      if response["success"]
        format.js
      else
        format.js
        format.html { redirect_to root_path, alert: "Ha ocurrido un error a agregar el producto" }
      end
    end
  end

  def delete_product
    # DEBE retornar la cantidad de productos {total: 3} o en su caso un  null si se elimina por completo
    # response =
  end

  def update_item
    respond_to do |format|
      default_response = @current_cart.update_item(params["item_id"], params["item"]["quantity"], params["item"]["plus"], user_signed_in?)
      format.json { render json: default_response }
    end
  end

  private

  def set_current_cart
    @current_cart = current_user.carts.find_by(place_id: params["place_id"])
  end


end
