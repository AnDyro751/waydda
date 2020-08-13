class CartsController < ApplicationController

  # before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:show, :update_item, :add_product]

  def show
    @items = @current_cart.cart_items.includes(:model).to_a
    @items = @items.each do |i|
      i["string_id"] = i.id.to_s
      i["model_reference"] = i.model
      i["model_reference_id"] = i.model.id.to_s
    end
    @total = Cart.get_total(@items)
    respond_to do |format|
      format.html { render :show }
      format.json { render json: {items: @items, total: @total} }
    end
  end

  def add_product
    response = @current_cart.update_item(params["product_id"], 1, true)
    respond_to do |format|
      if response["success"]
        format.js
      else
        # TODO: Show message in js
        # TODO: Se puede agregar al carrito sin iniciar sesión
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
