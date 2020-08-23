class DeliveryOptionsController < ApplicationController
  before_action :set_place
  before_action :set_delivery_option

  def update
    respond_to do |format|

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
    @delivery_option = @current_cart
                           .delivery_options
                           .find_or_create_by(
                               place: @place,
                           )
  end

  def set_place
    @place = Place.find_by(slug: params["place_id"]) || not_found
  end
end
