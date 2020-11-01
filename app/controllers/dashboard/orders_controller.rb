class Dashboard::OrdersController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_order, only: [:send_order, :process_order, :show, :edit, :update, :cancel_order, :destroy]

  def index
    set_meta_tags title: "Todas las ventas | Panel de control",
                  description: "Todas las ventas - Panel de control"
    add_breadcrumb "Mis ventas", dashboard_orders_path
    if params[:filter].nil?
      @sales = @place.orders.includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Todas las ventas", dashboard_orders_path
    elsif params[:filter] === "process"
      @sales = @place.orders.where(status: "in_process").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Pedidos en proceso", dashboard_orders_path
    elsif params[:filter] === "pending"
      @sales = @place.orders.where(status: "pending").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Pedidos pendientes", dashboard_orders_path
    elsif params[:filter] === "cancelled"
      @sales = @place.orders.where(status: "cancelled").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Pedidos cancelados", dashboard_orders_path
    elsif params[:filter] === "sent"
      add_breadcrumb "Pedidos enviados", dashboard_orders_path
      @sales = @place.orders.where(status: "sent").includes(:order_items).paginate(page: params[:page], per_page: 30)
    else
      redirect_to dashboard_orders_path, notice: "No se ha encontrado el filtro de búsqueda"
    end
    if params[:page].present?
      unless params[:page] === "1"
        add_breadcrumb "Página ##{params[:page]}", dashboard_orders_path
      end
    end
  end

  def show
    set_meta_tags title: "Venta - #{@order.uuid} | Panel de control",
                  description: "Venta - #{@order.uuid} - Panel de control"
  end

  def process_order
    respond_to do |format|
      if @order.pending?
        begin
          @order.to_process!
          format.js
        rescue => e
          logger.warn "-----------ERROR #{e} #LN OrdersController"
          format.html { redirect_to dashboard_order_path(@order), notice: "No se ha podido procesar la orden" }
        end
      else
        format.html { redirect_to dashboard_order_path(@order), notice: "No se ha podido procesar la orden" }
      end
    end
  end

  def send_order
    respond_to do |format|
      if @order.available_for_shipping?
        begin
          @order.to_process!
          format.js
        rescue => e
          logger.warn "-----------ERROR #{e} #LN OrdersController"
          format.html { redirect_to dashboard_order_path(@order), notice: "No se ha podido procesar la orden" }
        end
      else
        format.html { redirect_to dashboard_order_path(@order), notice: "No se ha podido procesar la orden" }
      end
    end
  end


  private

  def set_order
    @order = @place.orders.find_by(id: params["order_id"] || params["id"]) || not_found
  end
end
