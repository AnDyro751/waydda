class Dashboard::SalesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place

  def index
    set_meta_tags title: "Todas las ventas | Panel de control",
                  description: "Todas las ventas - Panel de control"
    add_breadcrumb "Mis ventas", dashboard_sales_path
    if params[:filter].nil?
      @sales = @place.orders.includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Todas las ventas", dashboard_sales_path
    elsif params[:filter] === "process"
      @sales = @place.orders.where(status: "in_process").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Pedidos en proceso", dashboard_sales_path
    elsif params[:filter] === "pending"
      @sales = @place.orders.where(status: "pending").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Pedidos pendientes", dashboard_sales_path
    elsif params[:filter] === "cancelled"
      @sales = @place.orders.where(status: "cancelled").includes(:order_items).paginate(page: params[:page], per_page: 30)
      add_breadcrumb "Pedidos cancelados", dashboard_sales_path
    elsif params[:filter] === "sent"
      @sales = @place.orders.where(status: "sent").includes(:order_items).paginate(page: params[:page], per_page: 30)
    else
      redirect_to dashboard_sales_path, notice: "No se ha encontrado el filtro de búsqueda"
    end
    if params[:page].present?
      unless params[:page] === "1"
        add_breadcrumb "Página ##{params[:page]}", dashboard_sales_path
      end
    end
  end

  def show
  end

  def edit
  end
end
