class DeliveryOptionsController < ApplicationController
  before_action :set_place
  before_action :set_delivery_option

  def update
    respond_to do |format|
      @big = params["size"].present?
      # @total = Cart.get_total(@current_cart.cart_items.includes(:products))
      unless params["to_state"].present?
        format.html { redirect_to place_path(@place.slug), alert: "Ha ocurrido un error" }
      end
      if !@place.delivery_option and params["to_state"] === "delivery"
        format.html { redirect_to place_path(@place.slug), alert: "Este comercio no permite los envíos a domicilio" }
      else
        if @delivery_option.update(kind: params["to_state"])
          format.js
        else
          format.js
        end
      end
    end
  end


  private


  def set_delivery_option
    @current_cart = Cart.find_by(id: params["cart_id"])
    not_found if @current_cart.nil?
    @delivery_option = @current_cart.delivery_option
    if @delivery_option.nil?
      @delivery_option = @current_cart.create_delivery_option
    end
  end

  def set_place
    @place = Place.find_by(slug: params["place_id"]) || not_found
  end
end
