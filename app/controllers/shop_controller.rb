class ShopController < ApplicationController
  skip_before_action :authenticate_user!
  before_action { @section = 'shop' }

  # GET /shop or /shop.json
  def index
    @shop_products = Shop::Product.all#.includes(:user, user: :player)
    @shopping_cart = Shop::ShoppingCart.find_latest(request.remote_ip, current_user&.id, session['session_id'])
    # handle filter parameter
    @shop_products = @shop_products.where(user_id: params[:seller]) if params[:seller].present?
    @shop_products = @shop_products.where(subtype: params[:subtype]) if params[:subtype].present?
    # handle order parameter
    if params[:order].present?
      sanitizedOrder = ActiveRecord::Base.sanitize_sql_for_order(params[:order].gsub('-', ' '))
      @shop_products = @shop_products.order(Arel.sql(sanitizedOrder))
    else
      @shop_products = @shop_products.order(updated_at: :desc) # default: Latest first
    end
    # in any case order by user_id & position at the end
    @shop_products = @shop_products.order(:user_id, :position)
    # save current shop_products_count to be able to show a new_releases icon
    cookies.permanent[:shop_products_count] = @shop_products.count
  end

end
