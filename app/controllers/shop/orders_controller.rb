class Shop::OrdersController < ApplicationController
  #before_action :authenticate_user!, only: %i[ index new create edit update ]
  before_action :authenticate_super_admin!, only: %i[ destroy ]
  before_action :set_shop_order, only: %i[ edit update destroy ]
  before_action :set_shopping_cart, only: %i[ new create ]
  before_action { @section = 'shop_orders' }

  # GET /shop_orders
  def index
    scope = ShopOrder.includes(:shopping_cart, shopping_cart: [:user, :shop_purchases, shop_purchases: :shop_product]).order(created_at: :desc)
    @shop_orders = current_user.super_admin? ? scope.all : scope.where(shopping_cart: {user_id: current_user.id})
  end

  # GET /shop_order
  def edit
    @shopping_cart = @shop_order.shopping_cart
    render :new
  end

  # GET /checkout
  def new
    @shop_order = ShopOrder.new
    if @shopping_cart.user.present?
      customer = @shopping_cart.user.customer
      @shop_order.organisation = customer.name unless customer.is_private
      @shop_order.name = customer.name_long
      @shop_order.address = customer.address
      @shop_order.address2 = customer.address2
      @shop_order.zip_code = customer.zip_code
      @shop_order.city = customer.city
      @shop_order.phone_number = customer.phone_number
      @shop_order.email = customer.email
    end
  end

  # POST /shop_order/1
  def create
    @shop_order = ShopOrder.new(shop_order_params)
    @shop_order.shopping_cart_id = @shopping_cart.id
    @shop_order.status = 'open'
    # delete all old orders with the same shopping_cart_id as there should only be one order per shopping_cart
    ShopOrder.where(shopping_cart_id: @shopping_cart.id).destroy_all
    respond_to do |format|
      if @shop_order.save
        # invoice payment: instantly complete order as its handled manually and may take a while
        if @shop_order.payment_method == 'invoice'
          @shop_order.complete!(current_app_mode)
          format.html { redirect_to shop_orders_path, notice: t('flash.shop_order_created') }
          format.json { render :new, status: :ok, location: @shop_order }
        else
          # stripe payment: complete order in /shop/stripe/success
          format.html { redirect_to shop_stripe_checkout_path(order_id: @shop_order.id) }
          format.json { render :new, status: :ok, location: @shop_order }
        end
      else
        format.html { render :new, status: :unprocessable_entity, alert: t('flash.shop_order_not_created') }
        format.json { render json: @shop_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shop_order/1
  def update
    respond_to do |format|
      if @shop_order.update(shop_order_params)
        format.html { redirect_to shop_orders_path, notice: t('flash.shop_order_updated') }
        format.json { render :edit, status: :ok, location: @shop_order }
      else
        format.html { redirect_to shop_orders_path, alert: t('flash.shop_order_not_updated') }
        format.json { render json: @shop_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shop_order/1
  def destroy
    respond_to do |format|
      if @shop_order.revert_checkout
        @shop_order.shopping_cart.destroy # this also destroys shop_order
        format.html { redirect_to shop_orders_path, notice: t('flash.shop_order_deleted') }
        format.json { head :no_content }
      else
        format.html { redirect_to shop_orders_path, alert: t('flash.shop_order_not_deleted') }
        format.json { render json: @shop_order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop_order
      @shop_order = ShopOrder.find(params[:id])
    end

    def set_shopping_cart
      @shopping_cart = ShoppingCart.find_latest(request.remote_ip, current_user&.id, session['session_id'])
      redirect_to shop_path unless @shopping_cart.present?
    end

    # Only allow a list of trusted parameters through.
    def shop_order_params
      params.require(:shop_order).permit(
        :organisation, :name, :address, :address2, :zip_code, :city, :email,
        :phone_number, :was_order_sent, :was_order_paid, :payment_method
      )
    end

end
