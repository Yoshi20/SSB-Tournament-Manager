class ShopController < ApplicationController
  skip_before_action :authenticate_user!
  before_action { @section = 'shop' }

  # GET /shop or /shop.json
  def index
    @shop_products = ShopProduct.all.order(:position, :created_at)
    # @shopping_cart = ShoppingCart.find_latest(request.remote_ip, current_user&.id, session['session_id'])
  end

end
