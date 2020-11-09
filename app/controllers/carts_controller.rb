class CartsController < ApplicationController
  layout "cart"
  # before_action :authenticate_user!, except: [:add_product]
  Stripe.api_key = 'sk_test_51H9CZeBOcPJ0nbHctTzfQZhFXBnn8j05e0xqJ5RSVz5Bum72LsvmQKIecJnsoHISEg0jUWtKjERYGeCAEWiIAujP00Fae9MiKm'
  before_action :set_place, only: [:create_charge, :success, :payment_method, :show, :add_product, :update_item]
  before_action :login_or_continue_as_guest, only: [:show, :success]
  before_action :set_current_cart, only: [:create_charge, :add_product, :payment_method, :show, :update_item]
  before_action :set_product, only: [:add_product]
  before_action :set_current_cart_item, only: [:update_item]
  before_action :set_cart_items, only: [:show]
  before_action :set_current_address, only: [:create_charge]
  before_action :set_available_distance, only: [:show, :success]
  skip_before_action :verify_authenticity_token, only: [:update_item, :create_charge]

  def delivery_option

  end

  def payment_method
    respond_to do |format|
      if @current_cart.update(payment_type: params["cart"]["payment_type"])
        @new_payment_method = params["cart"]["payment_type"] === "cash" ? "card" : "cash"
        format.js
      else
        format.html { redirect_to place_my_cart_path(@place.slug), notice: "Ha ocurrido un error al actualizar el carrito" }
      end
    end
  end

  def show
    respond_to do |format|
      @address = current_or_guest_user.current_address || current_or_guest_user.addresses.new
      format.html { render :show }
      format.json { render "carts/show" }
      format.js
    end
  end


  def success
    @current_cart = current_or_guest_user.carts.find_by(id: params["cart_id"]) || not_found
    if @current_cart.status != "status"
      not_found
    end
  end


  def create_charge
    respond_to do |format|
      @items = @current_cart.cart_items.includes(:product).to_a
      @total = Cart.get_total(@items)
      if @current_cart.payment_type === "cash"
        begin
          puts "TOTAL DE LA ORDER#{@total}"
          if @current_cart.create_new_cash_order(place: @place, address: @current_address, current_or_guest_user: current_or_guest_user, total: @total)
            format.html { redirect_to place_success_checkout_path(@place.slug, @current_cart), alert: "Tu compra se ha realizado" }
          else
            format.html { redirect_to place_my_cart_path(@place.slug), alert: "Ha ocurrido un error al procesar el pago" }
          end
        rescue => e
          logger.warn "ERROR AL CREAR EL CARGO #{e}"
          format.html { redirect_to place_my_cart_path(@place.slug), notice: "Ha ocurrido un error al procesar el pago" }
        end
      else
        if @place.can_accept_payment_method?(payment_method: "card")
          begin

            if @current_cart.create_new_card_order(place: @place, address: @current_address, current_or_guest_user: current_or_guest_user, total: @total, token_id: params["stripeToken"])
              format.html { redirect_to place_success_checkout_path(@place.slug, @current_cart), alert: "Tu pedido se ha realizado con exito" }
            else
              format.html { redirect_to place_my_cart_path(@place.slug), notice: "Ha ocurrido un error al procesar el cargo" }
            end
          rescue => e
            logger.warn "HA OCURRIDO UN ERROR AL CREAR EL CARGO #{e.message}"
            format.html { redirect_to place_my_cart_path(@place.slug), notice: "#{e.message}" }
          end
        else
          format.html { redirect_to place_my_cart_path(@place.slug), notice: "El método de pago seleccionado no está disponible" }
        end
      end
    end
  end

  def add_product
    respond_to do |format|
      @error = nil
      begin
        puts "-----------------NUEVA CANTIDAD AL CARRITO #{params["cart_item"]["quantity"].to_i}"
        if @current_cart.add_item(product: @product, place: @place, quantity: if params["cart_item"].present?
                                                                                (params["cart_item"]["quantity"] || 1).to_i > 0 ? (params["cart_item"]["quantity"] || 1).to_i : 1
                                                                              else
                                                                                1
                                                                              end, aggregates: Cart.seralize_params(params: params))
          format.js
        else
          @error = "Ha ocurrido un error"
          format.js
          #   # format.html { redirect_to root_path, alert: "Ha ocurrido un error a agregar el producto", status: :unprocessable_entity }
        end
      rescue => e
        format.js
        @error = e.message || "Ha ocurrido un error"
      end
    end
  end

  def delete_product
    # DEBE retornar la cantidad de productos {total: 3} o en su caso un  null si se elimina por completo
    # response =
  end

  def update_item
    @in_sidebar = params["cart_item"]["element"].present?
    respond_to do |format|
      begin
        if @cart_item.update_quantity(quantity: params["cart_item"]["quantity"].to_i, force: true, add: params["cart_item"]["quantity"].to_i > @cart_item.quantity)
          set_cart_items
          if @cart_items.length <= 0
            if @in_sidebar
              format.html { redirect_to place_path(@place.slug), alert: "No hay productos en tu carrio" }
            else
              format.html { redirect_to place_my_cart_path(@place.slug), alert: "No hay productos en tu carrio" }
            end
          else
            format.js
          end
        else
          format.html { redirect_to place_my_cart_path(@place.slug), notice: "Ha ocurrido un error al actualizar el carrito" }
        end
      rescue => e
        logger.warn "ERROR AL ACTUALIZAR EL CARRITO --- #{e}"
        format.html { redirect_to place_my_cart_path(@place.slug), notice: "Ha ocurrido un error al actualizar el carrito" }
      end
    end
  end

  private

  def set_place
    if params["place_id"].present?
      @place = Place.find_by('$or' => [{id: params["place_id"]}, {slug: params["place_id"]}]) || not_found
    end
  end

  def set_product
    (@product = @place.products.find_by(slug: params["product_id"])) or not_found
  end

  def set_current_cart
    if params["cart_id"].present?
      @current_cart = current_or_guest_user.carts.find_by(id: params["cart_id"], status: "pending") || not_found
    else
      @current_cart = current_or_guest_user.carts.find_or_create_by(place: @place, status: "pending") || not_found
    end
  end

  def set_cart_items
    if params["place_id"].present?
      @cart_items = CartItem.where(cart: @current_cart, :product_id.nin => ["", nil]).includes(:product).to_a
      @cart_items.each do |ci|
        ci["product_record"] = ci.product
      end
      @total = Cart.get_total(@cart_items)
    else
      cart_items_ids = []
      @carts = current_or_guest_user.carts.where(status: "pending", :quantity.gt => 0).includes(:place).to_a.each do |ct|
        cart_items_ids = cart_items_ids + ct.cart_item_ids
      end
      @total = 0
      @cart_items = CartItem.where(:_id.in => cart_items_ids).includes(:product).to_a.each do |ci|
        ci["product_record"] = ci.product.attributes.slice(:name, :description, :price, :photo)
      end
      @carts.each do |ct|
        ct["place_record"] = ct.place
        ct["items"] = @cart_items.select { |ci| ci.cart_id.to_s == ct.id.to_s }
      end
      @total = @total + Cart.get_total(@cart_items)
    end
  end

  def set_available_distance
    @available_distance = @place.available_distance?(current_or_guest_user.get_ll)
  end

  def login_or_continue_as_guest
    unless session[:continue_as_guest]
      session[:user_return_to] = place_my_cart_path(@place.slug)
      redirect_to new_user_session_path
    end
  end

  def set_current_cart_item
    @cart_item = CartItem.find_by(id: params["cart_item_id"]) || not_found
  end


end
