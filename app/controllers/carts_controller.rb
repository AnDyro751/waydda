class CartsController < ApplicationController

  # before_action :authenticate_user!

  def show
    @items = @current_cart.cart_items.includes(:model).to_a
    @items = @items.each do |i|
      i["string_id"] = i.id.to_s
      i["model_reference"] = i.model
    end
    @total = Cart.get_total(@items)
  end

  def add_product
    response = @current_cart.add_item(params["product_id"])
    respond_to do |format|
      if response[0]
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
      format.json { render json: {total: 3} }
    end
  end


end
