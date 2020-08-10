class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_checkout

  def show
  end

  private

  def set_checkout
    current_checkout = @current_cart.checkout
    if current_checkout
      unless current_checkout.id.to_s == params["id"]
        not_found
      end
    else
      not_found
    end
  end

end
