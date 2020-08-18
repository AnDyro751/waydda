class CartsController < ApplicationController
  layout "cart"
  Stripe.api_key = 'sk_test_51H9CZeBOcPJ0nbHctTzfQZhFXBnn8j05e0xqJ5RSVz5Bum72LsvmQKIecJnsoHISEg0jUWtKjERYGeCAEWiIAujP00Fae9MiKm'

  # before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:show, :update_item, :add_product]

  def show
    respond_to do |format|
      @custom_js = true
      @items = @current_cart.cart_items.includes(:model).to_a
      @items = @items.each do |i|
        i["string_id"] = i.id.to_s
        i["model_reference"] = i.model
        i["model_reference_id"] = i.model.id.to_s
      end
      @total = Cart.get_total(@items)
      format.html { render :show }
      format.json { render json: {items: @items, total: @total, current_address: @current_address} }
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
    response = @current_cart.update_item(params["product_id"], 1, true)
    respond_to do |format|
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


end
