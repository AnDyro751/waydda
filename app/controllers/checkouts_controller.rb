class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_checkout

  def show
    checkout_id = Checkout.get_intent(@current_cart)
    if checkout_id.nil?
      render json: {checkout_id: nil}, status: :unprocessable_entity
    else
      render json: {checkout_id: checkout_id}, status: :ok
    end
  end

  private

  def set_checkout
    @current_checkout = @current_cart.checkout
    if @current_checkout.nil?
      @current_checkout = @current_cart.create_checkout
    end
  end

end
