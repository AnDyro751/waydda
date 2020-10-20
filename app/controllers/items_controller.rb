class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_place, only: [:show, :index]
  before_action :set_current_cart, only: [:show, :index]

  # GET /items
  # GET /items.json
  def index
    @available_distance = @place.available_distance?(current_or_guest_user.get_ll)
    @items = @place.items.includes(:recent_products).select { |item| item.recent_products.length > 0 }
  end

  # GET /items/1
  # GET /items/1.json
  def show

  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_path(@place, @item), notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to dashboard_item_path(@item), notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  def set_place
    @place = Place.find_by(slug: params["place_id"])
    not_found if @place.nil?
    if current_user
      unless current_user.id == @place.user_id
        not_found if @place.pending?
      end
    else
      not_found if @place.pending?
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end


  def set_current_cart
    @current_cart = current_or_guest_user.carts.find_or_create_by(place: @place, status: "pending", delivery_kind: "pickup")
    if @current_cart
      @delivery_option = @current_cart.delivery_option
    end
  end


  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :place_id)
  end
end
