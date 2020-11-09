class Dashboard::CustomersController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_my_place
  add_breadcrumb "Clientes", :dashboard_customers_path

  def index
  end

  def show
  end
end
