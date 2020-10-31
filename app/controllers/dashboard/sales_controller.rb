class Dashboard::SalesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place

  def index
    set_meta_tags title: "Todas las ventas | Panel de control",
                  description: "Todas las ventas - Panel de control"
    add_breadcrumb "Mis ventas", dashboard_sales_path
    @sales = @place.orders.paginate(page: params[:page], per_page: 1)
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
