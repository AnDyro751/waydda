class CartsController < ApplicationController

  # before_action :authenticate_user!

  def add_product
    response = @current_cart.add_item(params["product_id"])
    respond_to do |format|
      if response[0]
        format.js
      else
        # TODO: Show message in js
        # TODO: Se puede agregar al carrito sin iniciar sesión
        format.html { redirect_to root_path, alert: "Ha ocurrido un error a agregar el producto" }
      end
    end
  end

  def delete_product
  end


end
