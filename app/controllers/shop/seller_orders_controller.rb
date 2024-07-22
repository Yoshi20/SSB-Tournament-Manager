class Shop::SellerOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_seller!
  before_action :set_shop_seller_order, only: %i[ show update ]
  before_action :authenticate_seller_order_owner!, only: %i[ show update ]
  before_action { @section = 'shop_seller_orders' }

  # GET /shop/seller_orders
  def index
    # blup: eventuell nur .paid seller_orders anzeigen?
    @shop_seller_orders = current_user.seller_orders.includes(:order, order: :shopping_cart).order(created_at: :desc)
  end

  # GET /shop/seller_order/1
  def show
    @shop_order = @shop_seller_order.order
  end

  # PATCH/PUT /shop/seller_order/1
  def update
    respond_to do |format|
      if @shop_seller_order.update(shop_seller_order_params)
        format.html { redirect_to shop_seller_orders_path, notice: t('flash.shop_order_updated') }
        format.json { render json: {}, status: :ok, location: @shop_seller_order }
      else
        format.html { redirect_to shop_seller_orders_path, alert: t('flash.shop_order_not_updated') }
        format.json { render json: @shop_seller_order.errors, status: :unprocessable_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop_seller_order
      @shop_seller_order = Shop::SellerOrder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_seller_order_params
      params.require(:shop_seller_order).permit(:was_order_sent)
    end

    def authenticate_seller!
      unless current_user.present? && (current_user.admin? || current_user.has_role?("seller"))
        respond_to do |format|
          format.html { redirect_to shop_path, alert: t('flash.alert.unauthorized') }
          format.json { render json: {}, status: :unauthorized }
        end
      end
    end

    def authenticate_seller_order_owner!
      unless current_user.present? && (@shop_seller_order.user_id == current_user.id || current_user.super_admin?)
        respond_to do |format|
          format.html { redirect_to shop_path, alert: t('flash.alert.unauthorized') }
          format.json { render json: @shop_seller_order.errors, status: :unauthorized }
        end
      end
    end

end
