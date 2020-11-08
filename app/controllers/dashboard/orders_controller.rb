class Dashboard::OrdersController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  before_action :set_order, only: [:send_order, :process_order, :show, :edit, :update, :cancel_order, :receive_order, :destroy]
  add_breadcrumb "Mis ventas", :dashboard_orders_path

  def index
    set_meta_tags title: "Todas las ventas | Panel de control",
                  description: "Todas las ventas - Panel de control"
    if params[:filter].nil?
      @sales = @place.orders.order_by(created_at: "desc").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Todas las ventas", dashboard_orders_path
    elsif params[:filter] === "process"
      @sales = @place.orders.order_by(created_at: "desc").where(status: "in_process").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Pedidos en proceso", dashboard_orders_path
    elsif params[:filter] === "pending"
      @sales = @place.orders.order_by(created_at: "desc").where(status: "pending").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Pedidos pendientes", dashboard_orders_path
    elsif params[:filter] === "cancelled"
      @sales = @place.orders.order_by(created_at: "desc").where(status: "cancelled").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Pedidos cancelados", dashboard_orders_path
    elsif params[:filter] === "sent"
      add_breadcrumb "Pedidos enviados", dashboard_orders_path
      @sales = @place.orders.order_by(created_at: "desc").where(status: "sent").includes(:order_items).paginate(page: params[:page], per_page: 30)
    elsif params[:filter] === "received"
      add_breadcrumb "Pedidos recibidos no enviados", dashboard_orders_path
      @sales = @place.orders.order_by(created_at: "desc").where(status: "received").includes(:order_items).paginate(page: params[:page], per_page: 30)
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
    set_meta_tags title: "Pedido ##{@order.uuid} | Panel de control",
                  description: "Pedido ##{@order.uuid} - Panel de control"
    add_breadcrumb "Pedido ##{@order.uuid}", dashboard_order_path(@order)
    # TODO: Mostrar productos vendidos con su respectivo aggregate
    # TODO: Mostrar el precio por producto
    # TODO: Mostrar total del pedido
  end

  def process_order
    respond_to do |format|
      if @order.pending? || @order.received?
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
          @order.to_sent!
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

  def receive_order
    respond_to do |format|
      begin
        if @order.pending?
          @order.to_receive!
          format.js
        else
          format.html { redirect_to dashboard_order_path(@order), notice: "Esta orden ya ha sido recibida" }
        end
      rescue => e
        logger.warn "ERROR AL CANCELAR LN # 80 #{e}"
        format.html { redirect_to dashboard_order_path(@order), notice: "Ha ocurrido un error al recibir la orden, #{e}" }
      end
    end
  end

  def cancel_order
    respond_to do |format|
      begin
        @order.to_cancel!
        format.js
      rescue => e
        logger.warn "ERROR AL CANCELAR LN # 79 #{e}"
        format.html { redirect_to dashboard_order_path(@order), notice: "No se ha podido cancelar la orden, #{e}" }
      end
    end
  end


  private

  def set_order
    @order = @place.orders.order_by(created_at: "desc").find_by(id: params["order_id"] || params["id"]) || not_found
  end
end
